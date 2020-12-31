import 'package:cabin_booking/model/school_year.dart';
import 'package:cabin_booking/model/school_year_manager.dart';
import 'package:flutter/material.dart';

final _defaultSchoolYears = {
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
};

class DayHandler with ChangeNotifier {
  DateTime _dateTime;
  SchoolYearManager _schoolYearManager;

  DayHandler([this._schoolYearManager]) {
    _dateTime = DateTime.now();
    _schoolYearManager ??= SchoolYearManager(_defaultSchoolYears);
  }

  DateTime get dateTime => _dateTime;

  set dateTime(DateTime dateTime) {
    _dateTime = dateTime;

    _schoolYearManager.changeToSchoolYearFrom(dateTime);

    notifyListeners();
  }

  bool get hasPreviousDay => _dateTime.isAfter(schoolYears.first.startDate);

  bool get hasNextDay => _dateTime.isBefore(schoolYears.last.endDate);

  void changeToNow() => dateTime = DateTime.now();

  void changeToNextDay() => dateTime = _dateTime.add(const Duration(days: 1));

  void changeToPreviousDay() =>
      dateTime = _dateTime.subtract(const Duration(days: 1));

  int get schoolYearIndex => _schoolYearManager.schoolYearIndex;

  set schoolYearIndex(int index) {
    _schoolYearManager.schoolYearIndex = index;

    if (!_schoolYearManager.schoolYear.includes(_dateTime)) {
      _dateTime = _schoolYearManager.schoolYear.startDate;

      notifyListeners();
    }
  }

  Set<SchoolYear> get schoolYears => _schoolYearManager.schoolYears;
}
