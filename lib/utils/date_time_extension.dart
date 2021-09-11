import 'package:cabin_booking/utils/time_of_day_extension.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

extension DateTimeExtension on DateTime {
  DateTime get dateOnly => DateTime(year, month, day);

  DateTime addTimeOfDay(TimeOfDay? timeOfDay) => DateTime.tryParse(
        '${DateFormat('yyyy-MM-dd').format(this)}'
        ' ${(timeOfDay ?? TimeOfDay.now()).format24Hour()}',
      )!;

  bool isSameDate(DateTime other) =>
      year == other.year && month == other.month && day == other.day;

  DateTime get firstDayOfWeek =>
      weekday == 1 ? this : subtract(Duration(days: weekday - 1));

  double toDouble() => millisecondsSinceEpoch / Duration.millisecondsPerDay;
}
