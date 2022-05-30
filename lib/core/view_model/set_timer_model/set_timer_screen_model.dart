import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:intl/intl.dart';
import 'package:reminder/core/view_model/base_model.dart';
import 'package:timezone/timezone.dart' as tz;

class SetTimerViewModel extends BaseModel {
  FlutterLocalNotificationsPlugin? fltNotification;

  TextEditingController titleController = TextEditingController();
  TextEditingController noteController = TextEditingController();

  DateTime? selectedDate;
  DateTime? time;

  DateTime? startTime;
  final currentTime = DateTime.now();

  //
  bool isOn = false;
  DateFormat formatter = DateFormat.yMMMMd('en_US');

  //
  final database = FirebaseDatabase.instance.reference();
  FirebaseAuth auth = FirebaseAuth.instance;

  //
  addData() {
    database.child('reminder').push().set({
      'title': titleController.text,
      'note': noteController.text,
      'date': selectedDate == null
          ? DateTime.now().toString().split(' ')[0]
          : selectedDate.toString().split(' ')[0],
      'time': time == null
          ? DateTime.now().toString().split(' ')[1].split('.')[0]
          : time.toString().split(' ')[1].split('.')[0],
      'id': DateTime.now().millisecondsSinceEpoch.toString(),
    });
    updateUI();
  }

  updateData(reminderId) async {
    dynamic data;
    String? reminderKey;
    await database.child("reminder").once().then((value) {
      data = value.snapshot.value;
      data.forEach((key, value) {
        if (reminderId == value['id']) {
          reminderKey = key;
        }
      });
    });
    database.child("reminder").child(reminderKey!).update({
      'title': titleController.text,
      'note': noteController.text,
      'date': selectedDate == null
          ? DateTime.now().toString().split(' ')[0]
          : selectedDate.toString().split(' ')[0],
      'time': time == null
          ? DateTime.now().toString().split(' ')[1].split('.')[0]
          : time.toString().split(' ')[1].split('.')[0]
    });
  }

  timeDiff() {
    final diff_dy = currentTime.difference(startTime!).inDays;
    final diff_hr = currentTime.difference(startTime!).inHours;
    final diff_mn = currentTime.difference(startTime!).inMinutes;
    // final diff_sc = currentTime.difference(startTime).inSeconds;

    print("dy: $diff_dy,hr: $diff_hr,mn: $diff_mn");
  }

  localNotification() {
    var androidSetting = const AndroidInitializationSettings("app_icon");
    var iosSettings = const IOSInitializationSettings();
    var settings =
        InitializationSettings(android: androidSetting, iOS: iosSettings);
    fltNotification = FlutterLocalNotificationsPlugin();
    fltNotification!.initialize(settings);
  }

  showNotification(int id, String title, String body) async {
    await fltNotification!.zonedSchedule(
      id,
      title,
      body,
      tz.TZDateTime.now(tz.local).add(const Duration(seconds: 2)),
      const NotificationDetails(
        android: AndroidNotificationDetails(
          "main_channel",
          "Main Channel",
          importance: Importance.max,
          priority: Priority.max,
        ),
        iOS: IOSNotificationDetails(
          sound: 'default.wav',
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        ),
      ),
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      androidAllowWhileIdle: true,
    );
  }
}
