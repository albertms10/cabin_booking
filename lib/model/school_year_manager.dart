import 'dart:collection';
import 'dart:convert' show json;

import 'package:cabin_booking/model/school_year.dart';
import 'package:cabin_booking/model/writable_manager.dart';
import 'package:flutter/foundation.dart';

Iterable<SchoolYear> _parseSchoolYears(String jsonString) =>
    (json.decode(jsonString) as List<dynamic>)
        .map<SchoolYear>((json) => SchoolYear.from(json));

class SchoolYearManager extends WritableManager<Set<SchoolYear>>
    with ChangeNotifier {
  late Set<SchoolYear> schoolYears;
  int? _schoolYearIndex;

  final void Function()? notifyExternalListeners;

  SchoolYearManager({
    Set<SchoolYear>? schoolYears,
    String fileName = 'school_year_manager',
    this.notifyExternalListeners,
  }) : super(fileName) {
    this.schoolYears = schoolYears ?? SplayTreeSet();
    schoolYearIndex = _currentSchoolYearIndex;
  }

  List<Map<String, dynamic>> schoolYearsToMapList() =>
      schoolYears.map((schoolYear) => schoolYear.toMap()).toList();

  int? get schoolYearIndex => _schoolYearIndex;

  set schoolYearIndex(int? schoolYearIndex) {
    if (schoolYearIndex == null) return;
    _schoolYearIndex = schoolYearIndex;
  }

  int? get _currentSchoolYearIndex => _schoolYearIndexFrom(DateTime.now());

  int? _schoolYearIndexFrom(DateTime dateTime) {
    if (schoolYears.isEmpty) return null;

    for (var i = 0; i < schoolYears.length - 1; i++) {
      if (dateTime.isAfter(schoolYears.elementAt(i).startDate!) &&
          dateTime.isBefore(schoolYears.elementAt(i + 1).startDate!)) {
        return i;
      }
    }

    return schoolYears.length - 1;
  }

  SchoolYear? get schoolYear =>
      schoolYearIndex != null ? schoolYears.elementAt(schoolYearIndex!) : null;

  Duration get totalWorkingDuration {
    var duration = const Duration();

    for (final schoolYear in schoolYears) {
      duration += schoolYear.workingDuration;
    }

    return duration;
  }

  void changeToPreviousSchoolYear() {
    if (schoolYearIndex == null) return;

    schoolYearIndex = schoolYearIndex! > 0 ? schoolYearIndex! - 1 : 0;
  }

  void changeToCurrentSchoolYear() => schoolYearIndex = _currentSchoolYearIndex;

  void changeToSchoolYearFrom(DateTime dateTime) =>
      schoolYearIndex = _schoolYearIndexFrom(dateTime);

  void changeToNextSchoolYear() {
    if (schoolYearIndex == null) return;

    schoolYearIndex = schoolYearIndex! < schoolYears.length - 1
        ? schoolYearIndex! + 1
        : schoolYears.length - 1;
  }

  void addSchoolYear(
    SchoolYear schoolYear, {
    bool notify = true,
  }) {
    schoolYears.add(schoolYear);

    if (notify) {
      notifyListeners();
      notifyExternalListeners?.call();
    }
  }

  void modifySchoolYear(
    SchoolYear schoolYear, {
    bool notify = true,
  }) {
    schoolYears
        .firstWhere((_schoolYear) => schoolYear.id == _schoolYear.id)
        .replaceWith(schoolYear);

    if (notify) {
      notifyListeners();
      notifyExternalListeners?.call();
    }
  }

  void removeSchoolYearsByIds(
    List<String> ids, {
    bool notify = true,
  }) {
    schoolYears.removeWhere((schoolYear) => ids.contains(schoolYear.id));

    if (notify) {
      notifyListeners();
      notifyExternalListeners?.call();
    }
  }

  @override
  Future<Set<SchoolYear>> readFromFile() async {
    try {
      final file = await fileManager.localFile(fileName);
      final content = await file.readAsString();

      final schoolYears = _parseSchoolYears(content);

      return SplayTreeSet.from(schoolYears);
    } catch (e) {
      return SplayTreeSet();
    }
  }

  @override
  Future<int> loadFromFile() async {
    schoolYears = await readFromFile();
    schoolYearIndex = _currentSchoolYearIndex;

    notifyListeners();

    return schoolYears.length;
  }

  @override
  Future<bool> writeToFile() async {
    final file = await fileManager.localFile(fileName);

    await file.writeAsString(
      json.encode(schoolYearsToMapList()),
    );

    return true;
  }
}
