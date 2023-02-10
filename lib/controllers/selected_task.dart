import 'package:get/get.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';
import 'package:wonder_tool/connectors/task.dart';
import 'package:wonder_tool/controllers/task.dart';
import 'package:wonder_tool/helpers/constants.dart';
import 'package:wonder_tool/models/task.dart';

class SelectedTaskController extends GetxController {
  final _taskConnector = TaskConnector();

  var selectedTask = TaskModel().obs;
  var type = TASK_TYPE_WORK.obs;
  var isStartTime = false.obs;
  var subTask = SubTaskModel().obs;
  var selectedTaskIndex = -1;

  final timerWatchController = StopWatchTimer();

  Future<void> selectTaskRunning(
    TaskModel task,
    SubTaskModel sub,
    String typeTask,
  ) async {
    selectedTask.value = task;
    type.value = typeTask;

    timerWatchController.onExecute.add(StopWatchExecute.reset);
    timerWatchController.onExecute.add(StopWatchExecute.start);

    isStartTime.value = true;
    subTask.value = sub;
  }

  Future<void> startTimer(
      TaskModel task, Rx<bool> isLoading, int index,) async {
    isLoading.value = true;
    selectedTaskIndex = index;
    final _subTask = await _taskConnector.startTimerTask(task.id, type.value);

    if (task.isNew) {
      task.isNew = false;
      Get.find<TaskController>().update();
    }

    if (_subTask != null) {
      selectedTask.value = task;

      timerWatchController.onExecute.add(StopWatchExecute.reset);
      timerWatchController.onExecute.add(StopWatchExecute.start);

      isStartTime.value = true;
      subTask.value = _subTask;
    }

    isLoading.value = false;
  }

  Future<void> playLoading(Rx<bool> isLoading) async {
    isLoading.value = true;
    await Future.delayed(const Duration(milliseconds: 200));
    isLoading.value = false;
  }

  Future<void> stopTimer(TaskModel task, Rx<bool> isLoading) async {
    isLoading.value = true;

    final _sub = await _taskConnector.stopTimerTask(
      task.id,
      subTask.value.historyId,
      type.value,
    );

    if (_sub != null) {
      isStartTime.value = false;
      timerWatchController.onExecute.add(StopWatchExecute.stop);
    }

    isLoading.value = false;
  }
}
