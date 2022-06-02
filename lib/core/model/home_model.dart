class ReminderData {
  String? note;
  String? title;
  String? date;
  String? time;
  String? id;
  bool? isSelected;

  // bool isSelected = false;
  ReminderData({
    this.note,
    this.title,
    this.date,
    this.time,
    this.id,
    this.isSelected,
    // required this.isSelected,
  });
}

class ScreenArguments {
  bool? isUpdate;
  String? reminderId;
  // bool? isSelected;

  ScreenArguments({
    this.isUpdate,
    this.reminderId,
  });
}
