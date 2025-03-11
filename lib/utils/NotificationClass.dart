import 'dart:math';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationClass {
  static FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static Future<void> initNotifications({onTap}) async {
    const InitializationSettings initializationSettings =
        InitializationSettings(
            android: AndroidInitializationSettings('@mipmap/ic_launcher'),
            iOS: DarwinInitializationSettings(
              requestAlertPermission: true,
              requestBadgePermission: true,
              requestSoundPermission: true,
            ));
    await flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onDidReceiveNotificationResponse: (value) {
      onTap();
    });
  }

  static Future<void> showNotification({title, body}) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      '1',
      'Channel',
      importance: Importance.high,
      priority: Priority.high,
    );

    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);

    int notificationId = _generateUniqueId();

    await flutterLocalNotificationsPlugin.show(
        notificationId, // Notification ID
        title,
        body,
        platformChannelSpecifics,
        payload: 'Custom Payload');
  }
  static int _generateUniqueId() {
    return Random().nextInt(100000); // Generates a random unique ID
  }
}
