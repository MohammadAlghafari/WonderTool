import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:wonder_tool/connectors/review.dart';
import 'package:wonder_tool/controllers/user.dart';
import 'package:wonder_tool/helpers/public.dart';
import 'package:wonder_tool/models/review.dart';
import 'package:wonder_tool/models/task_delivered.dart';
import 'package:wonder_tool/screens/main/menu/reviews/widgets/rate_option_item.dart';
import 'package:wonder_tool/themes/colors.dart';
import 'package:get/get.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:wonder_tool/themes/styles.dart';
import 'package:wonder_tool/widgets/animation_list.dart';
import 'package:wonder_tool/widgets/loading_progress.dart';

class AddReviewWidget extends StatelessWidget {
  final TaskDeiveredModel task;
  final ReviewModel review;
  final Function() onRead;

  const AddReviewWidget({
    Key? key,
    required this.task,
    required this.review,
    required this.onRead,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final userController = Get.find<UserController>();
    final feedbackTextController = TextEditingController(text: review.feedback);

    var _isAccepted = task.isAccepted.obs;
    final _isLoading = false.obs;

    void _addReview() async {
      if (!_isAccepted.value) {
        return;
      }

      _isLoading.value = true;

      final r = ReviewModel(
        userId: task.userId,
        taskId: task.id,
        rateOptions: review.rateOptions,
        isDelivery: _isAccepted.value,
        clientName: task.clientName,
        feedback: feedbackTextController.text,
      );

      bool _isSuccess = await ReviewConnector().addReview(r);
      if (_isSuccess) {
        if (!task.isAccepted && _isAccepted.value) {
          userController.readReviewNotification();
          onRead();
        }

        Get.back();
        Get.back();

        showSuccessSnackBar("Your review has been submitted successfully");
      }

      _isLoading.value = false;
    }

    return Obx(
      () => ListView(
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        shrinkWrap: true,
        padding: const EdgeInsets.symmetric(
          vertical: 20,
          horizontal: 25,
        ),
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AutoSizeText(
                    "${task.firstName} ${task.lastName}",
                    style: const TextStyle(
                      color: primaryColor,
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                  ),
                  const SizedBox(height: 5),
                  AutoSizeText(
                    "${task.name} - ${task.clientName}",
                    style: const TextStyle(
                      color: grayColor,
                      fontSize: 15,
                    ),
                    maxLines: 1,
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 30),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const AutoSizeText(
                "Accept Delivery?",
                style: TextStyle(
                  color: primaryColor,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
                maxLines: 1,
              ),
              Transform.scale(
                scale: 1.4,
                child: Switch(
                  inactiveTrackColor:
                      _isAccepted.value ? blueColor : lightGrayColor,
                  activeColor: blueColor,
                  value: _isAccepted.value,
                  onChanged: (value) {
                    _isAccepted.value = value;
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              AutoSizeText(
                "HOURS SPENT",
                style: TextStyle(
                  color: _isAccepted.value ? primaryColor : grayColor,
                  fontSize: 15,
                ),
                maxLines: 1,
              ),
              AutoSizeText(
                '${review.hoursSpent} Hours ${review.minutesSpent} Minutes',
                style: const TextStyle(
                  color: blueColor,
                  fontSize: 12,
                ),
                maxLines: 1,
              ),
            ],
          ),
          const SizedBox(height: 10),
          AnimationLimiter(
            child: ListView.builder(
              itemCount: review.rateOptions.length,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                return AnimationListWidget(
                  index: index,
                  isVertical: true,
                  child: RateOptionItemWidget(
                    rateOption: review.rateOptions[index],
                    rateOptionsData: review.rateOptions,
                    isCompleted: _isAccepted.value,
                    isAdded: true,
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 20),
          const AutoSizeText(
            "Your Feedback",
            style: smallTextInputWhiteStyle,
            maxLines: 1,
          ),
          const SizedBox(height: 5),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 10,
              vertical: 2,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              color: lightBlackColor,
            ),
            child: TextField(
              controller: feedbackTextController,
              maxLines: 5,
              style: const TextStyle(
                color: primaryColor,
                fontSize: 17,
              ),
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 5,
                  vertical: 10,
                ),
                enabledBorder: const OutlineInputBorder(
                  borderSide: BorderSide(
                    width: 0,
                    color: lightBlackColor,
                  ),
                ),
                focusedBorder: const OutlineInputBorder(
                  borderSide: BorderSide(
                    width: 0,
                    color: lightBlackColor,
                  ),
                ),
                hintText: "Feedback",
                hintStyle: TextStyle(
                  fontSize: 17,
                  color: primaryColor.withOpacity(0.5),
                ),
                filled: true,
              ),
            ),
          ),
          const SizedBox(height: 20),
          _isLoading.value
              ? const LoadingProgressWidget()
              : Center(
                  child: ElevatedButton(
                    onPressed: _addReview,
                    child: const AutoSizeText(
                      "Send",
                      maxLines: 1,
                    ),
                    style: ElevatedButton.styleFrom(
                      foregroundColor: secondColor,
                      backgroundColor: primaryColor,
                      padding: const EdgeInsets.symmetric(
                        vertical: 10,
                        horizontal: 30,
                      ),
                    ),
                  ),
                ),
        ],
      ),
    );
  }
}
