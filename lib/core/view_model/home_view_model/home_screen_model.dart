import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:intl/intl.dart';
import 'package:reminder/core/view_model/base_model.dart';

import '../../model/home_model.dart';

class HomeViewModel extends BaseModel {
  FlutterLocalNotificationsPlugin? fltNotification;

  bool isOn = false;
  DateFormat formatter = DateFormat.yMMMMd('en_US');
  dynamic data;
  List<ReminderData> reminderList = [];

  final database = FirebaseDatabase.instance.reference();
  FirebaseAuth auth = FirebaseAuth.instance;

  readData() {
    database.child('reminder').onValue.listen((value) {
      reminderList.clear();
      data = value.snapshot.value;
      data.forEach((key, value) {
        reminderList.add(
          ReminderData(
              title: value['title'],
              note: value['note'],
              date: value['date'],
              time: value['time'],
              id: value['id']),
        );
      });
      updateUI();
    });
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

  localNotification() {
    var androidSetting = const AndroidInitializationSettings("app_icon");
    var iosSettings = const IOSInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );
    var settings =
        InitializationSettings(android: androidSetting, iOS: iosSettings);
    fltNotification = FlutterLocalNotificationsPlugin();
    fltNotification!.initialize(settings);
  }

  showNotification() async {
    var androidDetails =
        const AndroidNotificationDetails("channelId", "channelName");
    var iosDetails = const IOSNotificationDetails();
    var details = NotificationDetails(android: androidDetails, iOS: iosDetails);
    await fltNotification!.show(0, "Hello", "Hello Rutvik", details);
  }
}
