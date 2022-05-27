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

//
//
/*
class ExtractArgumentsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as ScreenArguments;
    return Scaffold(
      appBar: AppBar(
        title: Text(args.title),
      ),
      body: Center(
        child: Text(args.reminderId),
      ),
    );
  }
}

//
//
class PassArgumentsScreen extends StatelessWidget {
  final String title;
  final String reminderId;
  PassArgumentsScreen({
    required this.title,
    required this.reminderId,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Center(
        child: Text(reminderId),
      ),
    );
  }
}
*/
