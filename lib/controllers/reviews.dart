// import 'package:get/get.dart';
// import 'package:wonder_tool/models/task_feedback.dart';

// class ReviewsController extends GetxController {
//   List<TaskFeedbackModel> tasks = [];

//   void setTasks(List<TaskFeedbackModel> t) {
//     tasks = t;
//   }

//   void readTask(String taskId) {
//     final task = tasks.firstWhereOrNull((t) => t.id == taskId);
//     if (task != null) {
//       task.isRead = true;
//       update();
//     }
//   }

//   void completeTask(String taskId) {
//     final task = tasks.firstWhereOrNull((t) => t.id == taskId);
//     if (task != null) {
//       task.isAccepted = true;
//       update();
//     }
//   }

//   void cancelTask(String taskId) {
//     final task = tasks.firstWhereOrNull((t) => t.id == taskId);
//     if (task != null) {
//       task.isAccepted = false;
//       update();
//     }
//   }
// }
