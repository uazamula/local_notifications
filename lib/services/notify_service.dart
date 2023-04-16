import 'dart:io';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;

// https://stackoverflow.com/questions/71690143/flutter-push-notification-when-app-is-closed
// https://stackoverflow.com/questions/69014546/flutter-local-notification-sound-not-working
class NotificationService {
  static final flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static Future<void> initNotification() async {
    var initializationSettingsAndroid =
        const AndroidInitializationSettings('@drawable/ic_launcher');
    var initializationSettingsIOS = DarwinInitializationSettings(
        requestAlertPermission: true,
        requestBadgePermission: true,
        requestSoundPermission: true,
        onDidReceiveLocalNotification: (
          int id,
          String? title,
          String? body,
          String? payload,
        ) async {});
    var initializationSettings = InitializationSettings(
        android: initializationSettingsAndroid, iOS: initializationSettingsIOS);
    await flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onDidReceiveNotificationResponse: (notificationResponse) async {});
  }

//TODO comment in if you need it
  // Future showNotification({
  //   int id = 0,
  //   String? title,
  //   String? body,
  //   String? payload,
  // }) async {
  //   return notificationsPlugin.show(
  //       id, title, body, await notificationDetails());
  // }

  static notificationDetails() {
    return NotificationDetails(
      android: AndroidNotificationDetails(
        // don't forget to change this value after you change other fields in this method
        'ch_id_1',
        'channelName',
        playSound: true,
        //sound: UriAndroidNotificationSound('assets/sound/anthem'),// doesn't work
        sound: RawResourceAndroidNotificationSound('anthem'),
        importance: Importance.max,
        priority: Priority.high,
      ),
      iOS: DarwinNotificationDetails(),
    );
  }

  static Future scheduleNotification({
    int? id,
    String? title,
    String? body,
    String? payload,
    required DateTime scheduleNotificationDateTime,
  }) async {
    return flutterLocalNotificationsPlugin.zonedSchedule(
      id!,
      title,
      body,
      tz.TZDateTime.from(scheduleNotificationDateTime, tz.local),
      await notificationDetails(),
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      androidAllowWhileIdle: true,
    );
  }

  static Future<void> deleteNotification({int? id}) async {
    await flutterLocalNotificationsPlugin.cancel(id!);
  }

  static bool? notificationsEnabled;

  static Future<bool?> requestPermissions() async {
    if (Platform.isIOS || Platform.isMacOS) {
      await flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
              IOSFlutterLocalNotificationsPlugin>()
          ?.requestPermissions(
            alert: true,
            badge: true,
            sound: true,
          );
      await flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
              MacOSFlutterLocalNotificationsPlugin>()
          ?.requestPermissions(
            alert: true,
            badge: true,
            sound: true,
          );
    } else if (Platform.isAndroid ) {
      final AndroidFlutterLocalNotificationsPlugin? androidImplementation =
          flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>();

      final bool? granted = await androidImplementation?.requestPermission();
      return  granted ?? false;
    }
    return null;
  }
}
