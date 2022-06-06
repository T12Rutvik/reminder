import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:intl/intl.dart';
import 'package:reminder/core/view_model/base_model.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:toast/toast.dart';

import '../../model/home_model.dart';

class HomeViewModel extends BaseModel {
  String? suppoter;
  bool? isSelected;

  DateFormat formatter = DateFormat.yMMMMd('en_US');
  FlutterLocalNotificationsPlugin? fltNotification;
  List<ReminderData> reminderList = [];

  final database = FirebaseDatabase.instance.reference();
  FirebaseAuth auth = FirebaseAuth.instance;

  readData() {
    dynamic data = 0;
    database.child('reminder').onValue.listen((value) {
      reminderList.clear();
      data = value.snapshot.value;
      if (data != null) {
        data.forEach((key, value) {
          reminderList.add(
            ReminderData(
              title: value['title'],
              note: value['note'],
              date: value['date'],
              time: value['time'],
              id: value['id'],
              isSelected: value['isSelected'],
            ),
          );
        });
        updateUI();
      }
    });
  }

  localNotification() {
    var androidSetting = const AndroidInitializationSettings("app_icon");
    var iosSettings = const IOSInitializationSettings();
    var settings = InitializationSettings(android: androidSetting, iOS: iosSettings);
    fltNotification = FlutterLocalNotificationsPlugin();
    fltNotification!.initialize(settings);
  }

  showNotification(int id, String title, String body, Duration duration) async {
    await fltNotification!.zonedSchedule(
      id,
      title,
      body,
      tz.TZDateTime.now(tz.local).add(duration),
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
      uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
      androidAllowWhileIdle: true,
    );
  }

  showToast(
    String msg, {
    int? duration,
    int? gravity,
  }) {
    Toast.show(msg, duration: duration, gravity: gravity);
  }

  timeConvert({required String time}) {
    String? t;

    var temp = int.parse(time.split(':')[0]);

    if (temp >= 12 && temp < 24) {
      t = 'pm';
    } else {
      t = 'am';
    }
    if (temp > 12) {
      temp = temp - 12;
      if (temp < 10) {
        time = time.replaceRange(0, 2, '0$temp');
        time += t;
      } else {
        time = time.replaceRange(0, 2, '$temp');
        time += t;
      }
    } else if (temp == 00) {
      time = time.replaceRange(0, 2, '12');
    } else {
      time += t;
    }
    return time;
  }
}
