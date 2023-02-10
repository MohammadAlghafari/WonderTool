import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get.dart';
import 'package:wonder_tool/connectors/data.dart';
import 'package:wonder_tool/helpers/constants.dart';
import 'package:wonder_tool/helpers/public.dart';
import 'package:wonder_tool/models/answer.dart';
import 'package:wonder_tool/models/question.dart';
import 'package:wonder_tool/screens/main/board.dart';
import 'package:wonder_tool/themes/colors.dart';
import 'package:wonder_tool/themes/styles.dart';
import 'package:wonder_tool/widgets/animation_list.dart';
import 'package:wonder_tool/widgets/custom_safe_area.dart';
import 'package:wonder_tool/widgets/loading_progress.dart';

class StartWorkScreen extends StatelessWidget {
  final int indexPage;

  const StartWorkScreen({
    Key? key,
    required this.indexPage,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var _selectedAnswer = const AnswerModel().obs;
    var _isLoading = false.obs;

    Future<void> _letsDoThis(String qId) async {
      if (_selectedAnswer.value.id.isEmpty) {
        showErrorSnackBar("Please select an answer");
        return;
      }

      _isLoading.value = true;
      bool isSuccess = await DataConnector()
          .addAnswerQuestion(qId, _selectedAnswer.value.id);

      if (isSuccess) {
        _isLoading.value = false;

        Get.off(() => BoardScreen(indexPage: indexPage));
      } else {
        _isLoading.value = false;
      }
    }

    return CustomSafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(
            horizontal: paddingHorizontal,
            vertical: paddingVertical,
          ),
          child: FutureBuilder(
              future: DataConnector().getQuestion(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const LoadingProgressWidget();
                } else {
                  if (snapshot.hasError) {
                    return AutoSizeText(snapshot.error.toString());
                  } else if (!snapshot.hasData) {
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      Get.off(() => BoardScreen(indexPage: indexPage));
                    });

                    return const SizedBox();
                  } else {
                    final _question = snapshot.data as QuestionModel;

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AutoSizeText(
                          _question.question,
                          style: bigTitleWhiteStyle,
                          maxLines: 4,
                        ),
                        const SizedBox(height: 40),
                        AnimationLimiter(
                          child: ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            itemCount: _question.answers.length,
                            itemBuilder: (context, index) {
                              return AnimationListWidget(
                                index: index,
                                isVertical: true,
                                child: AnswerWidget(
                                  answer: _question.answers[index],
                                  selectedValue: _selectedAnswer,
                                ),
                              );
                            },
                          ),
                        ),
                        const SizedBox(height: 70),
                        Obx(
                          () => _isLoading.value
                              ? const LoadingProgressWidget()
                              : Center(
                                  child: ElevatedButton(
                                    onPressed: () => _letsDoThis(_question.id),
                                    child: const AutoSizeText(
                                      "Let's do this!",
                                      maxLines: 1,
                                    ),
                                  ),
                                ),
                        ),
                      ],
                    );
                  }
                }
              }),
        ),
      ),
    );
  }
}

class AnswerWidget extends StatelessWidget {
  final AnswerModel answer;
  final Rx<AnswerModel> selectedValue;

  const AnswerWidget({
    Key? key,
    required this.answer,
    required this.selectedValue,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Theme(
        data: ThemeData(
          unselectedWidgetColor: primaryColor,
        ),
        child: InkWell(
          onTap: () {
            selectedValue.value = answer;
          },
          child: Row(
            children: [
              Transform.scale(
                scale: 1.3,
                child: Radio<AnswerModel>(
                  value: answer,
                  activeColor: primaryColor,
                  groupValue: selectedValue.value,
                  onChanged: (value) => selectedValue.value = value!,
                ),
              ),
              const SizedBox(width: 10),
              AutoSizeText(
                answer.text,
                style: const TextStyle(
                  color: primaryColor,
                  fontSize: 20,
                  letterSpacing: -0.4,
                ),
                maxLines: 1,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
