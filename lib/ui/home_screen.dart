import 'package:flutter/material.dart';
import 'package:reminder/core/model/home_model.dart';
import 'package:reminder/core/view_model/base_view.dart';
import 'package:reminder/core/view_model/home_view_model/home_screen_model.dart';

import '../core/routing/routes.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  HomeViewModel? model;

  @override
  Widget build(BuildContext context) {
    return BaseView<HomeViewModel>(
      builder: (buildContext, model, child) {
        return Scaffold(
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              Navigator.pushNamed(
                context,
                Routes.setTimerScreen,
                arguments: ScreenArguments(isUpdate: false),
              );
            },
            backgroundColor: const Color(0xFF9d2fc6),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
            child: const Icon(Icons.add),
          ),
          appBar: AppBar(
            title: Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Text(model.formatter.format(DateTime.now()),
                  style: const TextStyle(color: Color(0xFFf8ddf6))),
            ),
            backgroundColor: const Color(0xFF9d2fc6),
            actions: const [
              Icon(Icons.more_vert, size: 30, color: Color(0xFFf8ddf6)),
              SizedBox(
                width: 20,
              ),
            ],
          ),
          body: Padding(
            padding:
                const EdgeInsets.symmetric(vertical: 25.0, horizontal: 25.0),
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
                                Navigator.pushNamed(
                                  context,
                                  Routes.setTimerScreen,
                                  arguments: ScreenArguments(
                                      isUpdate: true,
                                      reminderId: model.reminderList
                                          .elementAt(index)
                                          .id),
                                );
                                model.showNotification();
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
                                      padding: const EdgeInsets.only(
                                          right: 13.0, bottom: 5),
                                      child: Row(
                                        children: [
                                          const Padding(
                                            padding:
                                                EdgeInsets.only(left: 30.0),
                                            child: Text(
                                              "every day",
                                              style: TextStyle(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.w300),
                                            ),
                                          ),
                                          const Spacer(),
                                          Switch(
                                            activeTrackColor:
                                                Colors.grey.shade300,
                                            inactiveTrackColor:
                                                Colors.grey.shade300,
                                            activeColor:
                                                const Color(0xFF9d2fc6),
                                            hoverColor: Colors.transparent,
                                            value: model.isOn,
                                            onChanged: (value) {
                                              model.isOn = value;
                                              setState(() {});
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          bottom: 14, left: 27),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          RichText(
                                            text: TextSpan(
                                              text: model
                                                  .timeConvert(
                                                    time: model.reminderList
                                                        .elementAt(index)
                                                        .time!
                                                        .replaceRange(
                                                            5, 8, ' '),
                                                  )
                                                  .toString()
                                                  .split(' ')[0],
                                              style: const TextStyle(
                                                  fontSize: 30,
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.w600),
                                              children: [
                                                TextSpan(
                                                  text: model
                                                      .timeConvert(
                                                          time: model
                                                              .reminderList
                                                              .elementAt(index)
                                                              .time!)
                                                      .toString()
                                                      .replaceRange(0, 8, ' '),
                                                  style: const TextStyle(
                                                      color: Colors.black,
                                                      fontWeight:
                                                          FontWeight.w300,
                                                      fontSize: 30),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 30.0, bottom: 14),
                                      child: Row(
                                        children: [
                                          Flexible(
                                            child: Text(
                                              model.reminderList
                                                  .elementAt(index)
                                                  .title!,
                                              overflow: TextOverflow.ellipsis,
                                              style: const TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.w500),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(left: 30.0),
                                      child: Row(
                                        children: [
                                          Icon(Icons.notes_outlined,
                                              color: Colors.grey.shade500),
                                          const SizedBox(
                                            width: 15,
                                          ),
                                          Flexible(
                                            child: Text(
                                              model.reminderList
                                                  .elementAt(index)
                                                  .note!,
                                              overflow: TextOverflow.ellipsis,
                                              style: const TextStyle(
                                                  fontSize: 17,
                                                  fontWeight: FontWeight.w200),
                                            ),
                                          )
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
                ElevatedButton(
                  onPressed: model.showNotification,
                  child: const Text('Notification'),
                ),
              ],
            ),
          ),
        );
      },
      onModelReady: (model) async {
        this.model = model;
        model.localNotification();
        model.readData();
      },
    );
  }
}
