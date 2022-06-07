import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:reminder/core/model/home_model.dart';
import 'package:reminder/core/view_model/base_view.dart';
import 'package:toast/toast.dart';

import '../core/model/home_model.dart';
import '../core/view_model/set_timer_model/set_timer_screen_model.dart';

class SetTimerScreen extends StatefulWidget {
  ScreenArguments? screenArguments;

  SetTimerScreen({Key? key, this.screenArguments}) : super(key: key);

  @override
  State<SetTimerScreen> createState() => _SetTimerScreenState();
}

class _SetTimerScreenState extends State<SetTimerScreen> {
  SetTimerViewModel? model;

  @override
  Widget build(BuildContext context) {
    ToastContext().init(context);
    return BaseView<SetTimerViewModel>(
      builder: (buildContext, model, child) {
        return Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: Text(
              widget.screenArguments!.isUpdate! ? "Update Reminder" : "Create Reminder",
              style: TextStyle(color: Colors.grey.shade800),
            ),
            elevation: 0.4,
            backgroundColor: Colors.white,
            leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(Icons.arrow_back_ios_outlined, color: Colors.grey.shade800),
            ),
            actions: [
              Icon(Icons.more_vert, color: Colors.grey.shade800, size: 30),
              const SizedBox(
                width: 20,
              ),
            ],
          ),
          body: Form(
            key: model.formKey,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 250,
                      width: 280,
                      child: CupertinoDatePicker(
                        use24hFormat: false,
                        initialDateTime: model.time,
                        mode: CupertinoDatePickerMode.time,
                        onDateTimeChanged: (value) {
                          model.time = value;
                          DateTime tConvert = DateTime.parse("${model.selectedDate.toString().split(' ')[0]} ${value.toString().split(' ')[1]}");
                          model.tDiff = tConvert.difference(DateTime.now()).inSeconds;
                          setState(() {});
                        },
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 25.0, top: 20, bottom: 20),
                  child: Row(
                    children: [
                      GestureDetector(
                        child: Container(
                          width: 200,
                          height: 37,
                          decoration: BoxDecoration(borderRadius: BorderRadius.circular(9), color: Colors.grey.shade200),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Center(
                                child: Icon(Icons.date_range, color: Colors.grey.shade600),
                              ),
                              Text(
                                model.selectedDate == null
                                    ? model.formatter.format(DateTime.now()).toString()
                                    : model.formatter.format(model.selectedDate).toString(),
                                style: TextStyle(fontSize: 17, color: Colors.grey.shade800),
                              ),
                            ],
                          ),
                        ),
                        onTap: () {
                          showCupertinoModalPopup(
                            context: context,
                            builder: (BuildContext builder) {
                              return Container(
                                height: MediaQuery.of(context).copyWith().size.height * 0.25,
                                color: Colors.white,
                                child: CupertinoDatePicker(
                                  onDateTimeChanged: (value) {
                                    model.selectedDate = value;
                                    DateTime tConvert = DateTime.parse("${value.toString().split(' ')[0]} ${model.time.toString().split(' ')[1]}");
                                    model.tDiff = tConvert.difference(DateTime.now()).inSeconds;
                                    setState(() {});
                                  },
                                  initialDateTime: DateTime.now(),
                                  minimumYear: DateTime.now().year,
                                  maximumYear: 2025,
                                  minuteInterval: 1,
                                  minimumDate: DateTime.now().subtract(const Duration(seconds: 1)),
                                  mode: CupertinoDatePickerMode.date,
                                ),
                              );
                            },
                          );
                        },
                      ),
                    ],
                  ),
                ),
                const Divider(
                  thickness: 1.5,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 25),
                  child: Column(
                    children: [
                      Row(
                        children: const [
                          Text('Title', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w500)),
                        ],
                      ),
                      const SizedBox(
                        height: 12,
                      ),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(9),
                          color: Colors.grey.shade200,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 20.0, bottom: 8),
                          child: TextFormField(
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Please Enter Title.';
                              } else {
                                return null;
                              }
                            },
                            maxLines: 1,
                            controller: model.titleController,
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 40,
                      ),
                      Row(
                        children: const [
                          Text('Note', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w500)),
                        ],
                      ),
                      const SizedBox(
                        height: 12,
                      ),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(9),
                          color: Colors.grey.shade200,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(right: 15.0),
                          child: TextField(
                            controller: model.noteController,
                            keyboardType: TextInputType.multiline,
                            maxLines: 3,
                            decoration: InputDecoration(
                              prefixIcon: Padding(
                                padding: const EdgeInsets.only(left: 10.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: const [
                                    Icon(Icons.notes_outlined),
                                  ],
                                ),
                              ),
                              prefixIconColor: Colors.grey.shade300,
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                Container(
                  width: double.infinity,
                  height: 120,
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.shade100,
                        offset: const Offset(0, 1),
                        blurRadius: 10,
                        spreadRadius: 50,
                      ),
                    ],
                    color: Colors.white,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 35, bottom: 42, right: 35, top: 18),
                    child: model.tDiff <= 0
                        ? ElevatedButton(
                            onPressed: () {},
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(Colors.grey.shade400),
                              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(13),
                                ),
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(widget.screenArguments!.isUpdate! ? null : Icons.add),
                                const SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  widget.screenArguments!.isUpdate! ? "Update Reminder" : "Create Reminder",
                                  style: const TextStyle(fontSize: 20),
                                ),
                              ],
                            ),
                          )
                        : ElevatedButton(
                            onPressed: () async {
                              print(model.time);
                              print(model.selectedDate);

                              DateTime tConvert =
                                  DateTime.parse("${model.selectedDate.toString().split(' ')[0]} ${model.time.toString().split(' ')[1]}");
                              int tDiff = tConvert.difference(DateTime.now()).inSeconds;
                              print('xyz:::$tConvert');
                              print('abc:::$tDiff');
                              if (tDiff < 0) {
                                model.showToast("You are selected Past Time", gravity: Toast.bottom, duration: Toast.lengthLong);
                              } else {
                                if (model.formKey.currentState!.validate()) {
                                  if (widget.screenArguments!.isUpdate!) {
                                    int abc = int.parse(model.uid.toString());
                                    model.fltNotification!.cancel(abc);
                                    model.updateData(widget.screenArguments!.reminderId);
                                    model.showNotification(
                                      model.uid,
                                      model.titleController.text,
                                      model.noteController.text,
                                      Duration(
                                        seconds: tDiff,
                                      ),
                                    );
                                    Navigator.pop(context);
                                  } else {
                                    model.addData();
                                    // model.fltNotification!.cancelAll();
                                    DateTime tConvert =
                                        DateTime.parse("${model.selectedDate.toString().split(' ')[0]} ${model.time.toString().split(' ')[1]}");
                                    int tDiff = tConvert.difference(DateTime.now()).inSeconds;
                                    int h, m, s;
                                    int value = tDiff;

                                    h = value ~/ 3600;
                                    String hourLeft = h.toString().length < 2 ? "0" + h.toString() : h.toString();

                                    m = ((value - h * 3600)) ~/ 60;
                                    String minuteLeft = m.toString().length < 2 ? "0" + m.toString() : m.toString();

                                    s = value - (h * 3600) - (m * 60);
                                    String secondsLeft = s.toString().length < 2 ? "0" + s.toString() : s.toString();

                                    Navigator.pop(context);
                                    model.showToast("reminder set for $hourLeft hr $minuteLeft min and $secondsLeft sec",
                                        gravity: Toast.bottom, duration: Toast.lengthLong);
                                    model.showNotification(
                                      model.uid,
                                      model.titleController.text,
                                      model.noteController.text,
                                      Duration(
                                        seconds: tDiff,
                                      ),
                                    );
                                  }
                                }
                              }
                              model.formKey.currentState!.save();
                              // model.clearText();
                            },
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(Colors.purple),
                              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(13),
                                ),
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(widget.screenArguments!.isUpdate! ? null : Icons.add),
                                const SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  widget.screenArguments!.isUpdate! ? "Update Reminder" : "Create Reminder",
                                  style: const TextStyle(fontSize: 20),
                                ),
                              ],
                            ),
                          ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
      onModelReady: (model) async {
        this.model = model;
        model.getData();
        model.titleController.text = widget.screenArguments!.reminderTitle.toString();
        model.noteController.text = widget.screenArguments!.reminderNote.toString();
        model.time = DateTime.parse("${widget.screenArguments!.reminderDate.toString()} ${widget.screenArguments!.reminderTime.toString()}");
        print("000::${model.time}");
        model.selectedDate = DateTime.parse("${widget.screenArguments!.reminderDate.toString()} ${widget.screenArguments!.reminderTime.toString()}");
        print("111::${model.selectedDate}");
        model.localNotification();
      },
    );
  }
}
