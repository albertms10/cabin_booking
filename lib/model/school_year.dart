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

  SchoolYear.from(Map<String, dynamic> other) : super.from(other);

  @override
  String toString() =>
      '${DateFormat.y().format(startDate)}–${DateFormat.y().format(endDate)}';
}
