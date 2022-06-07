import 'package:flutter/material.dart';
import 'package:reminder/core/model/home_model.dart';
import 'package:reminder/core/view_model/base_view.dart';
import 'package:reminder/core/view_model/home_view_model/home_screen_model.dart';
import 'package:toast/toast.dart';

import '../core/routing/routes.dart';
import '../core/view_model/home_view_model/home_screen_model.dart';

class HomeScreen extends StatefulWidget {
  // ScreenArguments? screenArguments;

  const HomeScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  HomeViewModel? model;

  @override
  Widget build(BuildContext context) {
    ToastContext().init(context);
    return BaseView<HomeViewModel>(
      builder: (buildContext, model, child) {
        return Scaffold(
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              Navigator.pushNamed(
                context,
                Routes.setTimerScreen,
                arguments: ScreenArguments(
                  isUpdate: false,
                  reminderTitle: '',
                  reminderNote: '',
                  reminderDate: DateTime.now().toString().split(" ")[0],
                  reminderTime: DateTime.now().toString().split(' ')[1],
                  /*reminderTime: model.reminderList.elementAt(index).date.toString(),
                  reminderDate: DateTime.now().toString(),*/
                ),
              );
            },
            backgroundColor: const Color(0xFF9d2fc6),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
            child: const Icon(Icons.add),
          ),
          appBar: AppBar(
            title: Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(model.formatter.format(DateTime.now()), style: const TextStyle(color: Color(0xFFf8ddf6))),
                ],
              ),
            ),
            backgroundColor: const Color(0xFF9d2fc6),
          ),
          body: Padding(
            padding: const EdgeInsets.symmetric(vertical: 25.0, horizontal: 25.0),
            child: Column(
              children: [
                Row(
                  children: const [
                    Text(
                      'Your Reminder',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                Expanded(
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: model.reminderList.length,
                    itemBuilder: (BuildContext context, index) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            GestureDetector(
                              onTap: () {
                                /*print(
                                  model.reminderList.elementAt(index).date.toString(),
                                );
                                print(
                                  model.reminderList.elementAt(index).time.toString(),
                                );*/
                                Navigator.pushNamed(
                                  context,
                                  Routes.setTimerScreen,
                                  arguments: ScreenArguments(
                                    isUpdate: true,
                                    reminderId: model.reminderList.elementAt(index).id.toString(),
                                    reminderDate: model.reminderList.elementAt(index).date.toString(),
                                    reminderTime: model.reminderList.elementAt(index).time.toString(),
                                    reminderNote: model.reminderList.elementAt(index).note.toString(),
                                    reminderTitle: model.reminderList.elementAt(index).title.toString(),
                                  ),
                                );
                              },
                              child: Container(
                                width: double.infinity,
                                height: 178,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.shade200,
                                      offset: const Offset(0, 1),
                                      blurRadius: 5,
                                      spreadRadius: 1,
                                    ),
                                  ],
                                  color: Colors.white,
                                ),
                                child: Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(right: 13.0, bottom: 5),
                                      child: Row(
                                        children: [
                                          const Padding(
                                            padding: EdgeInsets.only(left: 30.0),
                                            child: Text(
                                              "every day",
                                              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w300),
                                            ),
                                          ),
                                          const Spacer(),
                                          Switch(
                                            activeTrackColor: Colors.grey.shade300,
                                            inactiveTrackColor: Colors.grey.shade300,
                                            activeColor: const Color(0xFF9d2fc6),
                                            hoverColor: Colors.transparent,
                                            value: model.reminderList.elementAt(index).isSelected!,
                                            onChanged: (val) {
                                              model.suppoter = model.reminderList.elementAt(index).id;
                                              dynamic data;
                                              model.database.child("reminder").once().then((value) {
                                                data = value.snapshot.value;
                                                data!.forEach((key, value) {
                                                  DateTime tConvert =
                                                      DateTime.parse("${value['date']} ${model.reminderList.elementAt(index).time!}.000");
                                                  int tDiff = tConvert.difference(DateTime.now()).inSeconds;
                                                  if (value['id'] == model.suppoter) {
                                                    model.database.child('reminder').child(key).update({
                                                      'isSelected': val,
                                                    });
                                                    if (val) {
                                                      if (tDiff < 0) {
                                                        tDiff = tDiff + 86400;
                                                        int h, m, s;
                                                        int value = tDiff;

                                                        h = value ~/ 3600;
                                                        String hourLeft = h.toString().length < 2 ? "0" + h.toString() : h.toString();

                                                        m = ((value - h * 3600)) ~/ 60;
                                                        String minuteLeft = m.toString().length < 2 ? "0" + m.toString() : m.toString();

                                                        s = value - (h * 3600) - (m * 60);
                                                        String secondsLeft = s.toString().length < 2 ? "0" + s.toString() : s.toString();

                                                        model.showToast("reminder will show in $hourLeft hr $minuteLeft min and $secondsLeft sec",
                                                            gravity: Toast.bottom, duration: Toast.lengthLong);
                                                      }
                                                      print(tDiff);
                                                      model.showNotification(
                                                          int.parse(model.reminderList.elementAt(index).id!),
                                                          model.reminderList.elementAt(index).title!,
                                                          model.reminderList.elementAt(index).note!,
                                                          Duration(seconds: tDiff));
                                                    } else {
                                                      int abc = int.parse(model.reminderList.elementAt(index).id.toString());
                                                      model.fltNotification!.cancel(abc);
                                                    }
                                                  }
                                                });
                                              });
                                              model.reminderList.elementAt(index).isSelected = !model.reminderList.elementAt(index).isSelected!;
                                              setState(() {});
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(bottom: 14, left: 27),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: [
                                          RichText(
                                            text: TextSpan(
                                              text: model
                                                  .timeConvert(
                                                    time: model.reminderList.elementAt(index).time!.replaceRange(5, 8, ' '),
                                                  )
                                                  .toString()
                                                  .split(' ')[0],
                                              style: const TextStyle(fontSize: 30, color: Colors.black, fontWeight: FontWeight.w600),
                                              children: [
                                                TextSpan(
                                                  text: model
                                                      .timeConvert(time: model.reminderList.elementAt(index).time!)
                                                      .toString()
                                                      .replaceRange(0, 8, ' '),
                                                  style: const TextStyle(color: Colors.black, fontWeight: FontWeight.w300, fontSize: 30),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 30.0, bottom: 14),
                                      child: Row(
                                        children: [
                                          Flexible(
                                            child: Text(
                                              model.reminderList.elementAt(index).title!,
                                              overflow: TextOverflow.ellipsis,
                                              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 30.0),
                                      child: Row(
                                        children: [
                                          Icon(model.reminderList.elementAt(index).note == '' ? null : Icons.notes, color: Colors.grey.shade500),
                                          const SizedBox(
                                            width: 15,
                                          ),
                                          Flexible(
                                            child: Text(
                                              model.reminderList.elementAt(index).note!,
                                              overflow: TextOverflow.ellipsis,
                                              style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w200),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 4,
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
      onModelReady: (model) async {
        this.model = model;
        model.readData();
        model.localNotification();
      },
    );
  }
}
