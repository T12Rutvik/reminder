import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:reminder/core/view_model/base_model.dart';

class SetTimerViewModel extends BaseModel {
  TextEditingController titleController = TextEditingController();
  TextEditingController noteController = TextEditingController();
  DateTime? selectedDate;
  DateTime? time;

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
}
