import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wonder_tool/helpers/local_storage.dart';
import 'package:wonder_tool/models/user.dart';

class UserController extends GetxController {
  var user = UserModel().obs;
  int feedbackNotificationCount = 0;
  int reviewNotificationCount = 0;
  bool hasNewsNotification = false;
  bool hasTaskNotification = false;

  void readReviewNotification() {
    if (reviewNotificationCount > 0) {
      reviewNotificationCount -= 1;

      WidgetsBinding.instance.addPostFrameCallback((_) {
        update();
      });
    }
  }

  void readFeedbackNotification() {
    if (feedbackNotificationCount > 0) {
      feedbackNotificationCount -= 1;

      WidgetsBinding.instance.addPostFrameCallback((_) {
        update();
      });
    }
  }

  void readNewsNotification() {
    hasNewsNotification = false;
    boxStorage.write(IS_READ_NEWS, true);

    update();
  }

  void readTaskNotification() {
    hasTaskNotification = false;
    boxStorage.write(IS_READ_TASK, true);

    update();
  }

  void addReviewNotification() {
    reviewNotificationCount += 1;
    update();
  }

  void addFeedbackNotification() {
    feedbackNotificationCount += 1;
    update();
  }

  void addNewsNotification() {
    hasNewsNotification = true;
    boxStorage.write(IS_READ_NEWS, false);

    update();
  }

  void addTaskNotification() {
    hasTaskNotification = true;
    boxStorage.write(IS_READ_TASK, false);

    update();
  }
}
