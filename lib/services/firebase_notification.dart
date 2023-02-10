import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wonder_tool/controllers/user.dart';
import 'package:wonder_tool/helpers/constants.dart';
import 'package:wonder_tool/screens/splash/check_login.dart';
import 'package:wonder_tool/services/local_notification.dart';

class NotificationFirebase extends StatefulWidget {
  const NotificationFirebase({Key? key}) : super(key: key);

  @override
  State<NotificationFirebase> createState() => _NotificationFirebaseState();
}

class _NotificationFirebaseState extends State<NotificationFirebase> {
  final userController = Get.find<UserController>();

  @override
  void initState() {
    checkPermission();
    setNotificationsListener();

    FirebaseMessaging.onMessageOpenedApp.listen(onOpenMessageBackground);
    FirebaseMessaging.onMessage.listen((msg) async {
      RemoteNotification? notification = msg.notification;

      if (notification != null) {
        if (notification.body!.toLowerCase().contains(NOTIFICATION_NEWS)) {
          userController.addNewsNotification();
        } else if (notification.title!
            .toLowerCase()
            .contains(NOTIFICATION_FEEDBACK)) {
          userController.addFeedbackNotification();
        } else if (notification.title!
            .toLowerCase()
            .contains(NOTIFICATION_TASK)) {
          userController.addTaskNotification();
        } else if (notification.title!
            .toLowerCase()
            .contains(NOTIFICATION_REVIEW)) {
          userController.addReviewNotification();
        }

        await NotificationService.showNotification(
          notification.hashCode,
          notification.title!,
          notification.body!,
          "",
        );
      }
    });

    super.initState();
  }

  void checkPermission() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;

    await messaging.requestPermission();
  }

  Future<void> onOpenMessageBackground(RemoteMessage message) async {}

  void setNotificationsListener() async {
    await NotificationService.init();
    NotificationService.onNotifications.stream.listen(onClickLocalNotification);
  }

  void onClickLocalNotification(String? payload) {
    if (payload != null) {}
  }

  @override
  Widget build(BuildContext context) {
    return const CheckLoginScreen();
  }
}
