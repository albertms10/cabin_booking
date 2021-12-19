import 'dart:collection' show SplayTreeSet;

import 'package:intl/intl.dart';

import '../date/date_range.dart';
import '../date/holiday.dart';

abstract class _JsonFields {
  static const holidays = 'h';
}

class SchoolYear extends DateRange {
  late Set<Holiday> holidays;

  SchoolYear({
    String? id,
    DateTime? startDate,
    DateTime? endDate,
    Set<Holiday>? holidays,
  }) : super(
          id: id,
          startDate: startDate,
          endDate: endDate,
        ) {
    this.holidays = holidays ?? SplayTreeSet();
  }

  SchoolYear.from(Map<String, dynamic> other)
      : holidays = SplayTreeSet.from(
          (other[_JsonFields.holidays] as List<dynamic>)
              .cast<Map<String, dynamic>>()
              .map<Holiday>(Holiday.from),
        ),
        super.from(other);

  @override
  Map<String, dynamic> toJson() => {
        ...super.toJson(),
        _JsonFields.holidays:
            holidays.map((holiday) => holiday.toJson()).toList(),
      };

  Duration get holidaysDuration {
    var duration = Duration.zero;

    for (final holiday in holidays) {
      duration += holiday.duration;
    }

    return duration;
  }

  Duration get workingDuration => duration - holidaysDuration;

  @override
  void replaceWith(covariant SchoolYear item) {
    startDate = item.startDate;
    endDate = item.endDate;

    super.replaceWith(item);
  }

  @override
  String toString() {
    final bothExist = startDate != null && endDate != null;
    final isSameYear = bothExist && startDate!.year == endDate!.year;

    final startYear =
        startDate != null ? DateFormat.y().format(startDate!) : '';

    final endYear =
        endDate != null && !isSameYear ? DateFormat.y().format(endDate!) : '';

    return '$startYear'
        '${bothExist && !isSameYear ? '–' : ''}'
        '$endYear';
  }
}
