import 'package:get/get.dart';
import 'package:wonder_tool/controllers/news.dart';
import 'package:wonder_tool/controllers/selected_task.dart';
import 'package:wonder_tool/controllers/task.dart';
import 'package:wonder_tool/controllers/user.dart';

class BindingGetxControllers implements Bindings {
  @override
  void dependencies() {
    Get.put(UserController());
    Get.put(TaskController());
    Get.put(SelectedTaskController());
    Get.put(NewsController());
    // Get.put(ReviewsController());
    // Get.put(FeedbackController());
  }
}
