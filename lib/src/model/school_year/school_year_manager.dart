import 'dart:collection' show SplayTreeSet;
import 'dart:convert' show json;

import 'package:flutter/foundation.dart';

import '../file/file_manager.dart';
import '../file/writable_manager.dart';
import 'school_year.dart';

Iterable<SchoolYear> _parseSchoolYears(String jsonString) =>
    (json.decode(jsonString) as List<dynamic>)
        .cast<Map<String, dynamic>>()
        .map(SchoolYear.from);

class SchoolYearManager extends WritableManager<Set<SchoolYear>>
    with ChangeNotifier {
  late Set<SchoolYear> schoolYears;
  int? _schoolYearIndex;

  final VoidCallback? notifyExternalListeners;

  SchoolYearManager({
    Set<SchoolYear>? schoolYears,
    String fileName = 'school_year_manager',
    this.notifyExternalListeners,
  }) : super(fileName) {
    this.schoolYears = schoolYears ?? SplayTreeSet();
    schoolYearIndex = _currentSchoolYearIndex;
  }

  List<Map<String, dynamic>> schoolYearsToJson() =>
      schoolYears.map((schoolYear) => schoolYear.toJson()).toList();

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

    if (dateTime.isAfter(schoolYears.last.startDate!) &&
        dateTime.isBefore(schoolYears.last.endDate!)) {
      return schoolYears.length - 1;
    }
  }

  SchoolYear? get schoolYear =>
      schoolYearIndex != null && schoolYearIndex! < schoolYears.length
          ? schoolYears.elementAt(schoolYearIndex!)
          : null;

  Duration get totalWorkingDuration {
    var duration = Duration.zero;

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

  Set<SchoolYear> get _defaultSchoolYears => SplayTreeSet.from({
        SchoolYear(
          startDate: DateTime(2018, DateTime.september, 3),
          endDate: DateTime(2019, DateTime.july, 26),
        ),
        SchoolYear(
          startDate: DateTime(2019, DateTime.september, 2),
          endDate: DateTime(2020, DateTime.july, 25),
        ),
        SchoolYear(
          startDate: DateTime(2020, DateTime.september),
          endDate: DateTime(2021, DateTime.july, 24),
        ),
        SchoolYear(
          startDate: DateTime(2021, DateTime.august, 31),
          endDate: DateTime(2022, DateTime.july, 23),
        ),
      });

  @override
  Future<Set<SchoolYear>> readFromFile() async {
    try {
      final file = await fileManager.localFile(fileName);
      final content = await file.readAsUncompressedString();

      final schoolYears = _parseSchoolYears(content);

      return schoolYears.isEmpty
          ? _defaultSchoolYears
          : SplayTreeSet.from(schoolYears);
    } on Exception {
      return _defaultSchoolYears;
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

    await file.writeAsCompressedString(
      json.encode(schoolYearsToJson()),
    );

    return true;
  }
}
