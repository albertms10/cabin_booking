import 'package:cabin_booking/constants.dart';
import 'package:flutter/material.dart';

import '../school_year_collection.dart';

class DayHandler with ChangeNotifier {
  late DateTime _dateTime;
  late SchoolYearCollection schoolYearCollection;

  DayHandler([SchoolYearCollection? schoolYearCollection])
      : _dateTime = DateTime.now() {
    this.schoolYearCollection = schoolYearCollection ??
        SchoolYearCollection(notifyExternalListeners: notifyListeners);
  }

  DateTime get dateTime => _dateTime;

  set dateTime(DateTime dateTime) {
    _dateTime = dateTime;

    schoolYearCollection.changeToSchoolYearFrom(dateTime);

    notifyListeners();
  }

  bool get hasPreviousDay =>
      schoolYearCollection.schoolYears.isNotEmpty &&
      _dateTime.isAfter(schoolYearCollection.schoolYears.first.startDate!);

  bool get hasNextDay =>
      schoolYearCollection.schoolYears.isNotEmpty &&
      _dateTime.isBefore(schoolYearCollection.schoolYears.last.endDate!);

  bool get dateTimeIsNonSchool =>
      nonSchoolWeekdays.contains(dateTime.weekday) ||
      (schoolYearCollection.schoolYear?.isOnHolidays(dateTime) ?? false);

  void changeToNow() => dateTime = DateTime.now();

  void changeToNextDay() => dateTime = _dateTime.add(const Duration(days: 1));

  void changeToPreviousDay() =>
      dateTime = _dateTime.subtract(const Duration(days: 1));

  int? get schoolYearIndex => schoolYearCollection.schoolYearIndex;

  set schoolYearIndex(int? index) {
    schoolYearCollection.schoolYearIndex = index;

    if (!schoolYearCollection.schoolYear!.includes(_dateTime)) {
      if (schoolYearCollection.schoolYear!.includes(DateTime.now())) {
        changeToNow();
      } else {
        _dateTime = schoolYearCollection.schoolYear!.startDate!;
      }

      notifyListeners();
    }
  }
}
