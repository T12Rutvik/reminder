import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:reminder/core/view_model/base_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SetTimerViewModel extends BaseModel {
  TextEditingController titleController = TextEditingController();
  TextEditingController noteController = TextEditingController();
  DateTime? selectedDate;
  DateTime? time;
  int id = 0;

  //
  bool isOn = false;
  DateFormat formatter = DateFormat.yMMMMd('en_US');

  //
  final database = FirebaseDatabase.instance.reference();
  FirebaseAuth auth = FirebaseAuth.instance;

  //
  storeUid() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setInt('Uid', id);
  }

  getUid() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    int? idd = preferences.getInt('Uid');
    id = idd!;
  }

  addData() {
    id++;
    /* updateUI(); */
    database.child('reminder').push().set({
      'title': titleController.text,
      'note': noteController.text,
      'date': selectedDate == null
          ? DateTime.now().toString().split(' ')[0]
          : selectedDate.toString().split(' ')[0],
      'time': time == null
          ? DateTime.now().toString().split(' ')[1].split('.')[0]
          : time.toString().split(' ')[1].split('.')[0],
      'id': "rm-$id",
    });
  }

  updateData() {
    /*List<ReminderData> reminderList = [];
    dynamic data;
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
          ),
        );
      });
      updateUI();
    });*/
    dynamic data;
    database.child("reminder").once().then((value) {
      data = value.snapshot.value;
      data.forEach((key, value) {
        database.child("reminder").child(key).update({
          'title': titleController.text,
          'note': noteController.text,
          'date': selectedDate == null
              ? DateTime.now().toString().split(' ')[0]
              : selectedDate.toString().split(' ')[0],
          'time': time == null
              ? DateTime.now().toString().split(' ')[1].split('.')[0]
              : time.toString().split(' ')[1].split('.')[0],
        });
      });
    });
    /* database.child('reminder').child("-N2z5hh-eq3Cxl5vzwzQ").update({
      'title': titleController.text,
      'note': noteController.text,
      'date': selectedDate == null
          ? DateTime.now().toString().split(' ')[0]
          : selectedDate.toString().split(' ')[0],
      'time': time == null
          ? DateTime.now().toString().split(' ')[1].split('.')[0]
          : time.toString().split(' ')[1].split('.')[0],
    });*/
  }
}
