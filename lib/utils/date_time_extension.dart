import 'package:cabin_booking/utils/time_of_day_extension.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

extension DateTimeExtension on DateTime {
  DateTime get dateOnly => DateTime(year, month, day);

  DateTime addTimeOfDay(TimeOfDay? timeOfDay) => DateTime.tryParse(
        '${DateFormat('yyyy-MM-dd').format(this)}'
        ' ${(timeOfDay ?? TimeOfDay.now()).format24Hour()}',
      )!;

  bool isSameDateAs(DateTime other) =>
      year == other.year && month == other.month && day == other.day;

  DateTime get firstDayOfWeek =>
      weekday == 1 ? this : subtract(Duration(days: weekday - 1));

  double toDouble() => millisecondsSinceEpoch / Duration.millisecondsPerDay;

  /// Whether this [DateTime] refers to the same date as today.
  bool get isToday => isSameDateAs(DateTime.now());

  /// Whether this [DateTime] refers to the same date as yesterday.
  bool get isYesterday =>
      isSameDateAs(DateTime.now().subtract(const Duration(days: 1)));

  /// Whether this [DateTime] refers to the same date as tomorrow.
  bool get isTomorrow =>
      isSameDateAs(DateTime.now().add(const Duration(days: 1)));
}
