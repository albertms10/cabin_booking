import 'package:cabin_booking/model/school_year.dart';
import 'package:cabin_booking/model/school_year_manager.dart';
import 'package:flutter/material.dart';

final _defaultSchoolYears = [
  SchoolYear(
    startDate: DateTime(2018, DateTime.september, 3),
    endDate: DateTime(2019, DateTime.july, 26),
  ),
  SchoolYear(
    startDate: DateTime(2019, DateTime.september, 2),
    endDate: DateTime(2020, DateTime.july, 25),
  ),
  SchoolYear(
    startDate: DateTime(2020, DateTime.september, 1),
    endDate: DateTime(2021, DateTime.july, 24),
  ),
  SchoolYear(
    startDate: DateTime(2021, DateTime.august, 31),
    endDate: DateTime(2022, DateTime.july, 23),
  ),
];

class DayHandler with ChangeNotifier {
  SchoolYearManager schoolYearManager;

  DayHandler([this.schoolYearManager]) {
    schoolYearManager ??= SchoolYearManager(_defaultSchoolYears);
  }

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
