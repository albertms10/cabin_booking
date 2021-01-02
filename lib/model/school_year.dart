import 'dart:collection';

import 'package:cabin_booking/model/date_range.dart';
import 'package:cabin_booking/model/holiday.dart';
import 'package:intl/intl.dart';

class SchoolYear extends DateRange {
  Set<Holiday> holidays;

  SchoolYear({
    String id,
    DateTime startDate,
    DateTime endDate,
    this.holidays,
  }) : super(
          id: id,
          startDate: startDate,
          endDate: endDate,
        ) {
    holidays ??= SplayTreeSet();
  }

  SchoolYear.from(Map<String, dynamic> other)
      : holidays = SplayTreeSet.from(
          (other['holidays'] as List<dynamic>)
              .map((holiday) => Holiday.from(holiday)),
        ),
        super.from(other);

  @override
  Map<String, dynamic> toMap() => {
        ...super.toMap(),
        'holidays': holidays.map((holiday) => holiday.toMap()).toList(),
      };

  Duration get holidaysDuration {
    var duration = const Duration();

    for (final holiday in holidays) {
      duration += holiday.duration;
    }

    return duration;
  }

  Duration get workDuration => duration - holidaysDuration;

  @override
  String toString() =>
      '${DateFormat.y().format(startDate)}–${DateFormat.y().format(endDate)}';
}
