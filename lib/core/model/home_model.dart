class ReminderData {
  String? note;
  String? title;
  String? date;
  String? time;
  ReminderData({this.note, this.title, this.date, this.time});
}

class ScreenArguments {
  final String title;
  final String name;

  ScreenArguments(this.title, this.name);
}
