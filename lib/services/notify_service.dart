import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
// https://stackoverflow.com/questions/71690143/flutter-push-notification-when-app-is-closed
// https://stackoverflow.com/questions/69014546/flutter-local-notification-sound-not-working
class NotificationService {
  final notificationsPlugin = FlutterLocalNotificationsPlugin();

  Future<void> initNotification() async {
    var initializationSettingsAndroid =
        const AndroidInitializationSettings('logo512circled');
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
    await notificationsPlugin.initialize(initializationSettings,
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

  notificationDetails() {
    return NotificationDetails(
      android: AndroidNotificationDetails(
        'channelId',
        'channelName',
        playSound: true,
        sound: UriAndroidNotificationSound('assets/anthem.mp3'),
        importance: Importance.high,
      ),
      iOS: DarwinNotificationDetails(),
    );
  }

  Future scheduleNotification({
    int id = 0,
    String? title,
    String? body,
    String? payload,
    required DateTime scheduleNotificationDateTime,
  }) async {
    return notificationsPlugin.zonedSchedule(
        id, title, body, tz.TZDateTime.from(scheduleNotificationDateTime, tz.local), await notificationDetails(),
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        androidAllowWhileIdle: true,
       );
  }

}