import 'package:cabin_booking/model/file_manager.dart';
import 'package:cabin_booking/model/school_year.dart';
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

class SchoolYearManager with ChangeNotifier, FileManager {
  List<SchoolYear> schoolYears;
  int schoolYearIndex;

  SchoolYearManager([this.schoolYears]) {
    schoolYears ??= _defaultSchoolYears;
    schoolYearIndex = _currentSchoolYearIndex;
  }

  int get _currentSchoolYearIndex {
    if (schoolYears.isEmpty) return null;

    final now = DateTime.now();

    for (var i = 0; i < schoolYears.length - 1; i++) {
      if (now.isAfter(schoolYears[i].startDate) &&
          now.isBefore(schoolYears[i + 1].startDate)) {
        return i;
      }
    }

    return schoolYears.length - 1;
  }

  SchoolYear get schoolYear => schoolYears[schoolYearIndex];

  void changeToPreviousSchoolYear() =>
      schoolYearIndex = schoolYearIndex > 0 ? schoolYearIndex - 1 : 0;

  void changeToCurrentSchoolYear() => schoolYearIndex = _currentSchoolYearIndex;

  void changeToNextSchoolYear() =>
      schoolYearIndex = schoolYearIndex < schoolYears.length - 1
          ? schoolYearIndex + 1
          : schoolYears.length - 1;
}
