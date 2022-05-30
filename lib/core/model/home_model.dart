class ReminderData {
  String? note;
  String? title;
  String? date;
  String? time;
  String? id;
  ReminderData({this.note, this.title, this.date, this.time, this.id});
}

class ScreenArguments {
  bool? isUpdate;
  String? reminderId;

  ScreenArguments({this.isUpdate, this.reminderId});
}
