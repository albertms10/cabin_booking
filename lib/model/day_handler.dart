import 'package:flutter/material.dart';

class DayHandler with ChangeNotifier {
  DateTime _dateTime = DateTime.now();

  DateTime get dateTime => _dateTime;

  set dateTime(DateTime value) {
    _dateTime = value;
    notifyListeners();
  }

  void now() => dateTime = DateTime.now();

  void nextDay() => dateTime = _dateTime.add(Duration(days: 1));

  void previousDay() => dateTime = _dateTime.subtract(Duration(days: 1));
}
