import 'package:flutter/material.dart';

class DayHandler with ChangeNotifier {
  DateTime _dateTime = DateTime.now();

  DateTime get dateTime => _dateTime;

  set dateTime(DateTime value) {
    _dateTime = value;
    notifyListeners();
  }

  void setNow() => dateTime = DateTime.now();

  void setNextDay() => dateTime = _dateTime.add(Duration(days: 1));

  void setPreviousDay() => dateTime = _dateTime.subtract(Duration(days: 1));
}
