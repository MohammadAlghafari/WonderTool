import 'package:auto_size_text/auto_size_text.dart';
// import 'package:custom_pop_up_menu/custom_pop_up_menu.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import 'package:wonder_tool/connectors/task.dart';
import 'package:wonder_tool/helpers/constants.dart';
import 'package:wonder_tool/helpers/public.dart';
import 'package:wonder_tool/models/task.dart';
import 'package:wonder_tool/controllers/selected_task.dart';
import 'package:wonder_tool/controllers/task.dart';
import 'package:wonder_tool/screens/main/work/widgets/start_task_item.dart';
import 'package:wonder_tool/themes/colors.dart';
import 'package:get/get.dart';
import 'package:wonder_tool/widgets/loading_progress.dart';

class TaskItemWidget extends GetView<TaskController> {
  final TaskModel task;
  final Function() refreshData;
  final int index;

  const TaskItemWidget({
    Key? key,
    required this.task,
    required this.refreshData,
    required this.index,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final selectTaskController = Get.find<SelectedTaskController>();
    var _isLoadingTimer = false.obs;
    final _taskConnector = TaskConnector();
    var _type = TASK_TYPE_WORK.obs;
    var _isOverDate = false.obs;

    // GlobalKey key = GlobalKey();

   /*  WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      RenderBox box = key.currentContext!.findRenderObject() as RenderBox;
      Offset position =
          box.localToGlobal(Offset.zero); //this is global position
      double y = position.dy; //thi
      print('y $y');
    }); */

    String _date = DateFormat('MMM, d, yyyy').format(task.deadLineDate!);

    Future<void> checkIfOutDate() async {
      final _now = DateTime.now();
      final _today = DateTime(_now.year, _now.month, _now.day);

      final _aDate = DateTime(
        task.deadLineDate!.year,
        task.deadLineDate!.month,
        task.deadLineDate!.day,
      );

      if (_today.compareTo(_aDate) >= 0) {
        _isOverDate.value = true;
      }
    }

    Future<void> checkTaskIfPlaying() async {
      if (selectTaskController.selectedTask.value.id != task.id &&
          selectTaskController.isStartTime.value) {
        await selectTaskController.stopTimer(
          selectTaskController.selectedTask.value,
          _isLoadingTimer,
        );
      }
    }

    void _selectTask(String type, int index) async {
      await checkTaskIfPlaying();
      await selectTaskController.playLoading(_isLoadingTimer);
      selectTaskController.type.value = type;
      _type.value = type;
      selectTaskController.startTimer(
        task,
        _isLoadingTimer,
        index,
      );
      Get.back();
    }

    void togglePinTask() async {
      if (task.isPin) {
        controller.removePinTask(task);
        controller.addUnpinTasks(task);

        controller.update();
      } else {
        controller.addPinTasks(task);
        controller.removeUnpinTask(task);

        controller.update();
      }

      bool _isSuccess = await _taskConnector.togglePinTask(task.id);

      if (!_isSuccess) {
        if (!task.isPin) {
          controller.removePinTask(task);
          controller.addUnpinTasks(task);

          controller.update();
        } else {
          controller.addPinTasks(task);
          controller.removeUnpinTask(task);

          controller.update();
        }

        showErrorSnackBar("Error occurred, Please try again");
      }
    }

    void deliverTask() async {
      if (selectTaskController.selectedTask.value.id == task.id &&
          selectTaskController.isStartTime.value) {
        await selectTaskController.stopTimer(
          selectTaskController.selectedTask.value,
          _isLoadingTimer,
        );
      }

      if (selectTaskController.selectedTask.value.id == task.id) {
        selectTaskController.selectedTask.value = TaskModel();
        selectTaskController.type.value = TASK_TYPE_WORK;
        selectTaskController.isStartTime.value = false;
        _type.value = TASK_TYPE_WORK;
      }

      if (task.isPin) {
        controller.removePinTask(task);
      } else {
        controller.removeUnpinTask(task);
      }

      controller.update();

      bool _isSuccess = await _taskConnector.deliveryTask(task.id);

      if (!_isSuccess) {
        if (task.isPin) {
          controller.addPinTasks(task);
          controller.update();
        } else {
          controller.addUnpinTasks(task);
          controller.update();
        }

        showErrorSnackBar("Error occurred, Please try again");
      } else {
        refreshData();
      }
    }

    checkIfOutDate();

    return Slidable(
      key: ValueKey(task.id),
      startActionPane: ActionPane(
        extentRatio: task.isPin ? 0.30 : 0.24,
        motion: const BehindMotion(),
        children: [
          InkWell(
            onTap: () => togglePinTask(),
            child: Container(
              margin: const EdgeInsets.only(bottom: 10),
              padding: const EdgeInsets.symmetric(horizontal: 30),
              decoration: const BoxDecoration(
                color: darkGrayColor,
              ),
              child: AutoSizeText(
                task.isPin ? "UnPin" : "Pin",
                style: const TextStyle(color: primaryColor, fontSize: 20),
                maxLines: 1,
              ),
              alignment: Alignment.centerLeft,
            ),
          ),
        ],
      ),
      endActionPane: ActionPane(
        extentRatio: 0.34,
        motion: const BehindMotion(),
        children: [
          InkWell(
            onTap: () => deliverTask(),
            child: Container(
              margin: const EdgeInsets.only(bottom: 10, left: 10),
              padding: const EdgeInsets.symmetric(horizontal: 30),
              decoration: const BoxDecoration(
                color: Color(0xFF0A84FF),
              ),
              child: const AutoSizeText(
                "Deliver",
                style: TextStyle(color: primaryColor, fontSize: 20),
                maxLines: 1,
              ),
              alignment: Alignment.centerLeft,
            ),
          ),
        ],
      ),
      child: Obx(
        () => AnimatedContainer(
          // key: key,
          duration: const Duration(milliseconds: 500),
          height:
              /* _isLoadingTimer.value && !selectTaskController.isStartTime.value
                  ? 150
                  : */
              90,
          margin: const EdgeInsets.only(bottom: 10),
          decoration: BoxDecoration(
            color:
                _isLoadingTimer.value && !selectTaskController.isStartTime.value
                    ? primaryColor
                    : lightBlackColor,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              AnimatedPositioned(
                height: /* _isLoadingTimer.value &&
                        !selectTaskController.isStartTime.value
                    ? 150
                    : */
                    95,
                width: MediaQuery.of(context).size.width,
                top: /* _isLoadingTimer.value &&
                        !selectTaskController.isStartTime.value
                    ? 40
                    : */
                    0,
                duration: const Duration(milliseconds: 500),
                child: Stack(
                  alignment: AlignmentDirectional.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 12, 30, 12),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            flex: 7,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    SizedBox(
                                      width: Get.size.width * 0.61,
                                      child: AutoSizeText(
                                        task.clientName,
                                        style: TextStyle(
                                          color: _isLoadingTimer.value &&
                                                  !selectTaskController
                                                      .isStartTime.value
                                              ? secondColor
                                              : primaryColor,
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        maxLines: 1,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 3),
                                AutoSizeText(
                                  task.name,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    color: _isLoadingTimer.value &&
                                            !selectTaskController
                                                .isStartTime.value
                                        ? lightBlackColor
                                        : lightGrayColor,
                                    fontSize: 15,
                                  ),
                                  maxLines: 1,
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: Obx(
                              () => Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  _isLoadingTimer.value
                                      ? LoadingProgressWidget(
                                          color: _isLoadingTimer.value &&
                                                  selectTaskController
                                                      .isStartTime.value
                                              ? primaryColor
                                              : secondColor,
                                        )
                                      : selectTaskController
                                                      .selectedTask.value.id ==
                                                  task.id &&
                                              selectTaskController
                                                  .isStartTime.value
                                          ? InkWell(
                                              onTap: () => selectTaskController
                                                  .stopTimer(
                                                      task, _isLoadingTimer),
                                              child: Container(
                                                width: 40,
                                                height: 40,
                                                decoration: const BoxDecoration(
                                                  color: secondColor,
                                                  shape: BoxShape.circle,
                                                ),
                                                padding:
                                                    const EdgeInsets.all(5),
                                                alignment: Alignment.center,
                                                child: const Icon(
                                                  Icons.pause,
                                                  color: primaryColor,
                                                  size: 30,
                                                ),
                                              ),
                                            )
                                          : StartTaskItemWidget(
                                              task: task,
                                              isLoadingTimer: _isLoadingTimer,
                                              type: _type,
                                              index: index,
                                              onClick: _selectTask,
                                            ),
                                  const SizedBox(height: 3),
                                  if (_date != "Jan, 1, 1970")
                                    AutoSizeText(
                                      _date,
                                      overflow: TextOverflow.ellipsis,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: _isOverDate.value
                                            ? redColor
                                            : blueColor,
                                        fontSize: 12,
                                      ),
                                      maxLines: 2,
                                    ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (task.isNew)
                      const Positioned(
                        bottom: 15,
                        right: 15,
                        child: CircleAvatar(
                          backgroundColor: blueColor,
                          radius: 5,
                        ),
                      ),
                    if (task.isPin)
                      Positioned(
                        top: 5,
                        right: 15,
                        child: Transform.rotate(
                          angle: 70,
                          child: const Icon(
                            Icons.push_pin_rounded,
                            color: lightGrayColor,
                            size: 17,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
