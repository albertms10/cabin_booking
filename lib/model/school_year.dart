import 'package:cabin_booking/model/date_range.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class SchoolYear extends DateRange {
  SchoolYear({
    String id,
    @required DateTime startDate,
    @required DateTime endDate,
  }) : super(
          id: id,
          startDate: startDate,
          endDate: endDate,
        );

  @override
  String toString() =>
      '${DateFormat.y().format(startDate)}–${DateFormat.y().format(endDate)}';
}
