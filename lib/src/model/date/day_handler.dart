import 'package:cabin_booking/constants.dart';
import 'package:flutter/material.dart';

import '../school_year/school_year_manager.dart';

class DayHandler with ChangeNotifier {
  late DateTime _dateTime;
  late SchoolYearManager schoolYearManager;

  DayHandler([SchoolYearManager? schoolYearManager]) {
    _dateTime = DateTime.now();
    this.schoolYearManager = schoolYearManager ??
        SchoolYearManager(notifyExternalListeners: notifyListeners);
  }

  DateTime get dateTime => _dateTime;

  set dateTime(DateTime dateTime) {
    _dateTime = dateTime;

    schoolYearManager.changeToSchoolYearFrom(dateTime);

    notifyListeners();
  }

  bool get hasPreviousDay =>
      schoolYearManager.schoolYears.isNotEmpty &&
      _dateTime.isAfter(schoolYearManager.schoolYears.first.startDate!);

  bool get hasNextDay =>
      schoolYearManager.schoolYears.isNotEmpty &&
      _dateTime.isBefore(schoolYearManager.schoolYears.last.endDate!);

  bool get dateTimeIsNonSchool =>
      nonSchoolWeekdays.contains(dateTime.weekday) ||
      schoolYearManager.schoolYear!.isOnHolidays(dateTime);

  void changeToNow() => dateTime = DateTime.now();

  void changeToNextDay() => dateTime = _dateTime.add(const Duration(days: 1));

  void changeToPreviousDay() =>
      dateTime = _dateTime.subtract(const Duration(days: 1));

  int? get schoolYearIndex => schoolYearManager.schoolYearIndex;

  set schoolYearIndex(int? index) {
    schoolYearManager.schoolYearIndex = index;

    if (!schoolYearManager.schoolYear!.includes(_dateTime)) {
      if (schoolYearManager.schoolYear!.includes(DateTime.now())) {
        changeToNow();
      } else {
        _dateTime = schoolYearManager.schoolYear!.startDate!;
      }

      notifyListeners();
    }
  }
}
