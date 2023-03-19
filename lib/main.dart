import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:intl/intl.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:push_notifications/services/notify_service.dart';

DateTime scheduleTime = DateTime.now();

Future main() async{
  WidgetsFlutterBinding.ensureInitialized();
  NotificationService().initNotification();
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
            ScheduleBtn()
          ],
        ),
      ),
    );
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
        DatePicker.showDateTimePicker(context,
            showTitleActions: true,
            onChanged: (date) => scheduleTime = date,
            onConfirm: (date) {});
      },
      child: Text('Select Date Time'),
    );
  }
}

class ScheduleBtn extends StatelessWidget {
  const ScheduleBtn({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        onPressed: () {
          debugPrint('Notification scheduled for $scheduleTime');
          NotificationService().scheduleNotification(
              title: 'Scheduled Notification',
              body: '${DateFormat('hh:mm').format(scheduleTime)}',
              scheduleNotificationDateTime: scheduleTime);
        },
        child: Text('Schedule notification'));
  }
}
