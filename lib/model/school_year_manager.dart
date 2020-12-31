import 'package:cabin_booking/model/school_year.dart';

class SchoolYearManager {
  Set<SchoolYear> schoolYears;
  int schoolYearIndex;

  SchoolYearManager(this.schoolYears) {
    schoolYearIndex = _currentSchoolYearIndex;
  }

  int get _currentSchoolYearIndex => _schoolYearIndexFrom(DateTime.now());

  int _schoolYearIndexFrom(DateTime dateTime) {
    if (schoolYears.isEmpty) return null;

    for (var i = 0; i < schoolYears.length - 1; i++) {
      if (dateTime.isAfter(schoolYears.elementAt(i).startDate) &&
          dateTime.isBefore(schoolYears.elementAt(i + 1).startDate)) {
        return i;
      }
    }

    return schoolYears.length - 1;
  }

  SchoolYear get schoolYear => schoolYears.elementAt(schoolYearIndex);

  void changeToPreviousSchoolYear() =>
      schoolYearIndex = schoolYearIndex > 0 ? schoolYearIndex - 1 : 0;

  void changeToCurrentSchoolYear() => schoolYearIndex = _currentSchoolYearIndex;

  void changeToSchoolYearFrom(DateTime dateTime) =>
      schoolYearIndex = _schoolYearIndexFrom(dateTime);

  void changeToNextSchoolYear() =>
      schoolYearIndex = schoolYearIndex < schoolYears.length - 1
          ? schoolYearIndex + 1
          : schoolYears.length - 1;
}
