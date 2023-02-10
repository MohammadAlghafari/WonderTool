import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wonder_tool/controllers/selected_task.dart';
import 'package:wonder_tool/helpers/constants.dart';
import 'package:wonder_tool/models/task.dart';
import 'package:wonder_tool/themes/colors.dart';

class StartTaskItemWidget extends StatelessWidget {
  final TaskModel task;
  final int index;
  final RxBool isLoadingTimer;
  final RxString type;
  final Function(String, int) onClick;

  const StartTaskItemWidget({
    Key? key,
    required this.task,
    required this.index,
    required this.isLoadingTimer,
    required this.type,
    required this.onClick,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final selectTaskController = Get.find<SelectedTaskController>();

    void showPopupMenu(LongPressStartDetails details) async {
      final res = await showMenu<int>(
        context: Get.context!,
        position: RelativeRect.fromLTRB(
          details.globalPosition.dx,
          details.globalPosition.dy,
          details.globalPosition.dx,
          details.globalPosition.dy,
        ),
        color: darkGrayColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(defaultRaduis),
        ),
        items: [
          PopupMenuItem<int>(
            child: ListTile(
              minVerticalPadding: 0,
              contentPadding: EdgeInsets.zero,
              dense: true,
              leading: const FittedBox(
                child: Text(
                  "Management",
                  style: TextStyle(
                    fontSize: 15,
                    color: primaryColor,
                  ),
                  maxLines: 1,
                ),
              ),
              trailing: Container(
                width: 25,
                height: 25,
                decoration: const BoxDecoration(
                  color: secondColor,
                  shape: BoxShape.circle,
                ),
                padding: const EdgeInsets.all(3),
                alignment: Alignment.center,
                child: const Icon(
                  Icons.play_arrow,
                  color: primaryColor,
                  size: 18,
                ),
              ),
            ),
            value: 1,
          ),
          const PopupMenuDivider(),
          PopupMenuItem<int>(
            child: ListTile(
              contentPadding: EdgeInsets.zero,
              dense: true,
              leading: const FittedBox(
                child: Text(
                  "Meeting",
                  style: TextStyle(
                    fontSize: 15,
                    color: primaryColor,
                  ),
                  maxLines: 1,
                ),
              ),
              trailing: Container(
                width: 25,
                height: 25,
                decoration: const BoxDecoration(
                  color: secondColor,
                  shape: BoxShape.circle,
                ),
                padding: const EdgeInsets.all(3),
                alignment: Alignment.center,
                child: const Icon(
                  Icons.play_arrow,
                  color: primaryColor,
                  size: 18,
                ),
              ),
            ),
            value: 2,
          ),
        ],
        elevation: 8.0,
      );

      switch (res) {
        case 1:
          onClick(TASK_TYPE_MANAGEMENT, index);
          break;
        case 2:
          onClick(TASK_TYPE_MEETING, index);
          break;
      }
    }

    Future<void> checkTaskIfPlaying() async {
      if (selectTaskController.selectedTask.value.id != task.id &&
          selectTaskController.isStartTime.value) {
        await selectTaskController.stopTimer(
          selectTaskController.selectedTask.value,
          isLoadingTimer,
        );
      }
    }

    void _startTimer() async {
      await checkTaskIfPlaying();

      await selectTaskController.playLoading(isLoadingTimer);
      selectTaskController.type.value = TASK_TYPE_WORK;
      type.value = TASK_TYPE_WORK;

      selectTaskController.selectedTask.value = TaskModel();
      await selectTaskController.startTimer(task, isLoadingTimer, index,);
    }

    return GestureDetector(
      onLongPressStart: showPopupMenu,
      onTap: _startTimer,
      child: Container(
        width: 40,
        height: 40,
        decoration: const BoxDecoration(
          color: secondColor,
          shape: BoxShape.circle,
        ),
        padding: const EdgeInsets.all(5),
        alignment: Alignment.center,
        child: const Icon(
          Icons.play_arrow,
          color: primaryColor,
          size: 30,
        ),
      ),
    );
  }
}
