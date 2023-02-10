import 'package:get/get.dart';
import 'package:wonder_tool/models/task.dart';

class TaskController extends GetxController {
  bool isLoading = false;

  List<TaskModel> pinTasks = [];
  List<TaskModel> unPinTasks = [];

  final searchPinTasks = <TaskModel>[].obs;
  final searchUnPinTasks = <TaskModel>[].obs;

  void toggleLoading() {
    isLoading = !isLoading;

    update();
  }

  void addAllPinTasks(List<TaskModel> tasks) {
    pinTasks = tasks;
    searchPinTasks.value = tasks;

    update();
  }

  void addAllUnpinTasks(List<TaskModel> tasks) {
    unPinTasks = tasks;
    searchUnPinTasks.value = tasks;

    update();
  }

  void addPinTasks(TaskModel task) {
    final newTask = TaskModel(
      id: task.id,
      deadLineDate: task.deadLineDate,
      isPin: true,
      name: task.name,
      clientName: task.clientName,
    );

    searchPinTasks.add(newTask);
  }

  void addUnpinTasks(TaskModel task) {
    final newTask = TaskModel(
      id: task.id,
      deadLineDate: task.deadLineDate,
      isPin: false,
      name: task.name,
      clientName: task.clientName,
    );

    searchUnPinTasks.add(newTask);
  }

  void removePinTask(TaskModel task) {
    pinTasks.remove(task);
    searchPinTasks.remove(task);
  }

  void removeUnpinTask(TaskModel task) {
    unPinTasks.remove(task);
    searchUnPinTasks.remove(task);
  }
}
