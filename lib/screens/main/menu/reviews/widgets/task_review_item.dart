import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:wonder_tool/models/task_delivered.dart';
import 'package:wonder_tool/screens/main/menu/reviews/review_details.dart';
import 'package:wonder_tool/themes/colors.dart';

class TaskReviewItemWidget extends StatelessWidget {
  final TaskDeiveredModel task;
  final Function() onRead;

  const TaskReviewItemWidget({
    Key? key,
    required this.task,
    required this.onRead,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Get.to(() => ReviewDetailsScreen(
              task: task,
              onRead: onRead,
            ));
      },
      child: Container(
        color: task.isAccepted ? secondColor : lightBlackColor,
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        child: ListTile(
          leading: task.isAccepted
              ? SvgPicture.asset(
                  'assets/icons/file_complete.svg',
                )
              : SvgPicture.asset(
                  'assets/icons/file_pending.svg',
                ),
          title: AutoSizeText(
            task.clientName,
            style: const TextStyle(
              color: primaryColor,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
            maxLines: 1,
          ),
          subtitle: Row(
            children: [
              AutoSizeText(
                task.name,
                style: const TextStyle(
                  color: lightGrayColor,
                  fontSize: 15,
                ),
                maxLines: 1,
              ),
              const SizedBox(width: 5),
              Flexible(
                child: AutoSizeText(
                  "(${task.firstName} ${task.lastName})",
                  style: const TextStyle(
                    color: blueColor,
                    fontSize: 13,
                  ),
                  maxLines: 1,
                ),
              ),
            ],
          ),
            trailing: task.isRead
              ? null
              : const CircleAvatar(
                  backgroundColor: blueColor,
                  radius: 5,
                ),
        ),
      ),
    );
  }
}
