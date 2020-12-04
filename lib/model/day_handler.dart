import 'package:flutter/material.dart';

class DayHandler with ChangeNotifier {
  DateTime _dateTime = DateTime.now();

  DateTime get dateTime => _dateTime;

  set dateTime(DateTime value) {
    _dateTime = value;
    notifyListeners();
  }

  void changeToNow() => dateTime = DateTime.now();

  void changeToNextDay() => dateTime = _dateTime.add(const Duration(days: 1));

  void changeToPreviousDay() =>
      dateTime = _dateTime.subtract(const Duration(days: 1));
}
