import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:rxdart/rxdart.dart';

class NotificationService {
  static final _notifications = FlutterLocalNotificationsPlugin();
  static final onNotifications = BehaviorSubject<String?>();

  static Future init() async {
    const android = AndroidInitializationSettings('@drawable/ic_notification');
    const ios = IOSInitializationSettings();
    const settings = InitializationSettings(android: android, iOS: ios);

    await _notifications.initialize(
      settings,
      onSelectNotification: (payload) => onNotifications.add(payload),
    );
  }

  static notificationDetails() {
    return const NotificationDetails(
      android: AndroidNotificationDetails(
        "Channel Id",
        "Channel Name",
        importance: Importance.max,
      ),
      iOS: IOSNotificationDetails(),
    );
  }

  static Future<void> showNotification(
    int id,
    String title,
    String body,
    String payload,
  ) async {
    await _notifications.show(
      id,
      title,
      body,
      notificationDetails(),
      payload: payload,
    );
  }
}
