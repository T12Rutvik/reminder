class ReminderData {
  String? note;
  String? title;
  String? date;
  String? time;
  String? id;
  bool? isSelected;

  ReminderData({
    this.note,
    this.title,
    this.date,
    this.time,
    this.id,
    this.isSelected,
  });
}

class ScreenArguments {
  bool? isUpdate;
  String? reminderId;
  String? reminderDate;
  String? reminderTime;
  String? reminderNote;
  String? reminderTitle;

  ScreenArguments({
    this.isUpdate,
    this.reminderId,
    this.reminderDate,
    this.reminderTime,
    this.reminderNote,
    this.reminderTitle,
  });
}
