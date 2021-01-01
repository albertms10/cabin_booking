import 'package:cabin_booking/model/date_range.dart';
import 'package:cabin_booking/model/holiday.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class SchoolYear extends DateRange {
  Set<Holiday> holidays;

  SchoolYear({
    String id,
    @required DateTime startDate,
    @required DateTime endDate,
    this.holidays,
  }) : super(
          id: id,
          startDate: startDate,
          endDate: endDate,
        ) {
    holidays ??= <Holiday>{};
  }

  SchoolYear.from(Map<String, dynamic> other)
      : holidays = (other['holidays'] as List<dynamic>)
            .map((holiday) => Holiday.from(holiday))
            .toSet(),
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
