import 'package:flutter/cupertino.dart';

class DayContainer extends StatelessWidget {
  const DayContainer({
    Key? key,
    this.day,
  }) : super(key: key);

  final String? day;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 35,
      width: 68,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(13),
        border: Border.all(
          color: const Color(0xFF9d2fc6),
        ),
      ),
      child: Center(
        child: Text(
          day!,
          style: const TextStyle(fontSize: 17),
        ),
      ),
    );
  }
}

class AlwaysDisabledFocusNode extends FocusNode {
  @override
  bool get hasFocus => false;
}
