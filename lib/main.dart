import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:intl/intl.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:local_notifications/services/notify_service.dart';
//for 33 API on Mac M1// https://stackoverflow.com/questions/73432326/failed-to-find-sync-for-id-0-in-flutter
DateTime scheduleTime = DateTime.now();
DateTime scheduleTime2 = DateTime.now();

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  NotificationService.initNotification();
  tz.initializeTimeZones();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  @override
  Widget build(BuildContext context) {
    String dateTime1 = DateFormat('yyyy/MM/dd  hh:mm').format(scheduleTime);
    String dateTime2 = DateFormat('yyyy/MM/dd  hh:mm').format(scheduleTime2);
    // NotificationService.notificationsPlugin.resolvePlatformSpecificImplementation<
    //     AndroidFlutterLocalNotificationsPlugin>()?.requestPermission();
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            //TODO comment in if you need it

            // ElevatedButton(
            //   onPressed: () {
            //     NotificationService().showNotification(
            //         title: 'Sarah Abs',
            //         body: "Hey! Simple notification",
            //         payload: 'sarah.abs');
            //   },
            //   child: Text('Simple Notification'),
            // ),
            // SizedBox(height: 16),
            // ElevatedButton(
            //   onPressed: () {},
            //   child: Text('Scheduled Notification'),
            // ),
            // SizedBox(height: 16),
            // ElevatedButton(
            //   onPressed: () {},
            //   child: Text('Remove Notification'),
            // ),

            SizedBox(height: 32),
            DatePickerTxt(),
            SizedBox(height: 16),
            buildButton(context),
            SizedBox(height: 16),
            Text('Годинник встановлено на $dateTime1'),
            Text('Годинник встановлено на $dateTime2'),
            ElevatedButton(
              onPressed: () {
                NotificationService.deleteNotification(id: 1);
              },
              child: Text('Delete 1st notification'),
            ),
            ElevatedButton(
              child: Text('Request permission (API 33+)'),
              onPressed: () => NotificationService.requestPermissions(),
            )
          ],
        ),
      ),
    );
  }

  Widget buildButton(BuildContext context) {
    return ElevatedButton(
        onPressed: () {
          if (scheduleTime.isAfter(DateTime.now())) {
            debugPrint('Notification scheduled for ${scheduleTime}');
            NotificationService.scheduleNotification(
                id: 1,
                title: 'Scheduled Notification1',
                body: '${DateFormat('hh:mm').format(scheduleTime)}',
                scheduleNotificationDateTime: scheduleTime);
            NotificationService.scheduleNotification(
                id: 2,
                title: 'Scheduled Notification2',
                body: '${DateFormat('hh:mm').format(scheduleTime2)}',
                scheduleNotificationDateTime: scheduleTime2);
            setState(() {});
          }
        },
        child: Text('Schedule notification'));
  }
}

class DatePickerTxt extends StatefulWidget {
  const DatePickerTxt({Key? key}) : super(key: key);

  @override
  _DatePickerTxtState createState() => _DatePickerTxtState();
}

class _DatePickerTxtState extends State<DatePickerTxt> {
  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        DatePicker.showDateTimePicker(context, showTitleActions: true,
            onChanged: (date) {
          scheduleTime = date;
          scheduleTime2 = scheduleTime.add(Duration(minutes: 1));
        }, onConfirm: (date) {});
      },
      child: Text('Select Date Time'),
    );
  }
}

// class ScheduleBtn extends StatelessWidget {
//   const ScheduleBtn({Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return ElevatedButton(
//         onPressed: () {
//           debugPrint('Notification scheduled for $scheduleTime');
//           NotificationService.scheduleNotification(
//               title: 'Scheduled Notification',
//               body: '${DateFormat('hh:mm').format(scheduleTime)}',
//               scheduleNotificationDateTime: scheduleTime);
//         },
//         child: Text('Schedule notification'));
//   }
// }
