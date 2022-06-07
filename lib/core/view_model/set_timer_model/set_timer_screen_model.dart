import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:intl/intl.dart';
import 'package:reminder/core/view_model/base_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:toast/toast.dart';
import 'package:uuid/uuid.dart';

class SetTimerViewModel extends BaseModel {
  FlutterLocalNotificationsPlugin? fltNotification;
  DateTime pastDate = DateTime.now();
  bool isButtonActive = true;
  int tDiff = 0;

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  var uid = 0;
  var uuid = const Uuid();
  SharedPreferences? pref;

  TextEditingController titleController = TextEditingController();
  TextEditingController noteController = TextEditingController();

  clearText() {
    titleController.clear();
    noteController.clear();
  }

  //
  DateTime selectedDate = DateTime.now();
  DateTime time = DateTime.now();

  //
  DateFormat formatter = DateFormat.yMMMMd('en_US');

  //
  final database = FirebaseDatabase.instance.reference();
  FirebaseAuth auth = FirebaseAuth.instance;

  //
  setData() async {
    pref = await SharedPreferences.getInstance();
    await pref!.setInt('uid', uid);
    updateUI();
  }

  getData() async {
    pref = await SharedPreferences.getInstance();
    uid = pref!.getInt('uid') ?? 0;
    updateUI();
  }

  addData() {
    uid++;
    database.child('reminder').push().set({
      'title': titleController.text,
      'note': noteController.text,
      'date': selectedDate == null ? DateTime.now().toString().split(' ')[0] : selectedDate.toString().split(' ')[0],
      'time': time == null ? DateTime.now().toString().split(' ')[1].split('.')[0] : time.toString().split(' ')[1].split('.')[0],
      'id': uid.toString(),
      'isSelected': true,
    });
    setData();
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
    print(titleController.text);
    database.child("reminder").child(reminderKey!).update({
      'title': titleController.text,
      'note': noteController.text,
      'date': selectedDate == null ? DateTime.now().toString().split(' ')[0] : selectedDate.toString().split(' ')[0],
      'time': time == null ? DateTime.now().toString().split(' ')[1].split('.')[0] : time.toString().split(' ')[1].split('.')[0],
      // 'id': uid.toString(),
    });
    setData();
    updateUI();
    // print(titleController.text);
  }

  localNotification() {
    var androidSetting = const AndroidInitializationSettings("app_icon");
    var iosSettings = const IOSInitializationSettings();
    var settings = InitializationSettings(android: androidSetting, iOS: iosSettings);
    fltNotification = FlutterLocalNotificationsPlugin();
    fltNotification!.initialize(settings);
  }

  showNotification(var id, String title, String body, Duration duration) async {
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
    Toast.show(
      msg,
      duration: duration,
      gravity: gravity,
    );
  }
}
