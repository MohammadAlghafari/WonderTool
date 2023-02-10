import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get.dart';
import 'package:wonder_tool/connectors/feedback.dart';
import 'package:wonder_tool/controllers/user.dart';
import 'package:wonder_tool/models/review.dart';
import 'package:wonder_tool/models/task_delivered.dart';
import 'package:wonder_tool/screens/main/menu/reviews/widgets/rate_option_item.dart';
import 'package:wonder_tool/themes/colors.dart';
import 'package:wonder_tool/themes/styles.dart';
import 'package:wonder_tool/widgets/animation_list.dart';
import 'package:wonder_tool/widgets/custom_app_bar.dart';
import 'package:wonder_tool/widgets/custom_safe_area.dart';
import 'package:wonder_tool/screens/main/menu/drawer.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:wonder_tool/widgets/loading_progress.dart';

class FeedbackDetailsScreen extends StatelessWidget {
  final TaskDeiveredModel task;
  final Function() onRead;

  const FeedbackDetailsScreen({
    Key? key,
    required this.task,
    required this.onRead,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (!task.isRead) {
      Get.find<UserController>().readFeedbackNotification();
      onRead();
    }

    return CustomSafeArea(
      child: Scaffold(
        endDrawer: const CustomDrawerWidget(),
        appBar: customeAppBar(title: "My Feedbacks", hasBack: true),
        body: FutureBuilder(
          future: FeedbackConnector().getFeedbackByTaskId(
            task.id,
            task.taskUserId,
            task.userId,
          ),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const LoadingProgressWidget();
            } else {
              if (snapshot.hasError) {
                return AutoSizeText(snapshot.error.toString());
              } else {
                final _reviews = snapshot.data as List<ReviewModel>;

                final _review = _reviews[0];

                return !_review.hasReview
                    ? const Center(
                        child: Text(
                          "Not Yet Reviewed",
                          style: TextStyle(color: primaryColor),
                        ),
                      )
                    : ListView(
                        padding:
                            const EdgeInsets.only(top: 20, left: 25, right: 25),
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
                                  inactiveTrackColor: task.isAccepted
                                      ? blueColor
                                      : lightGrayColor,
                                  activeColor: blueColor,
                                  value: task.isAccepted,
                                  onChanged: (value) {},
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
                                  color: task.isAccepted
                                      ? primaryColor
                                      : grayColor,
                                  fontSize: 15,
                                ),
                                maxLines: 1,
                              ),
                              AutoSizeText(
                                '${_review.hoursSpent}.${_review.minutesSpent}',
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
                              itemCount: _review.rateOptions.length,
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemBuilder: (context, index) {
                                return AnimationListWidget(
                                  index: index,
                                  isVertical: true,
                                  child: RateOptionItemWidget(
                                    rateOption: _review.rateOptions[index],
                                    rateOptionsData: _review.rateOptions,
                                    isCompleted: false,
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
                              controller: TextEditingController(
                                text: _review.feedback.isEmpty
                                    ? "No Feedback"
                                    : _review.feedback,
                              ),
                              maxLines: 5,
                              style: const TextStyle(
                                color: primaryColor,
                                fontSize: 17,
                              ),
                              decoration: const InputDecoration(
                                contentPadding: EdgeInsets.symmetric(
                                  horizontal: 5,
                                  vertical: 10,
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    width: 0,
                                    color: lightBlackColor,
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    width: 0,
                                    color: lightBlackColor,
                                  ),
                                ),
                                enabled: false,
                                filled: true,
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                        ],
                      );
              }
            }
          },
        ),
      ),
    );
  }
}
