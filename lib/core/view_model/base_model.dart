import 'package:flutter/material.dart';
import 'package:reminder/core/enum/view_state.dart';

class BaseModel extends ChangeNotifier {
  ViewState _state = ViewState.Idle;

  ViewState get state => _state;

  set state(ViewState value) {
    _state = value;
    notifyListeners();
  }

  updateUI() {
    notifyListeners();
  }
}
