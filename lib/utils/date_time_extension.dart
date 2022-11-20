import 'package:cabin_booking/utils/time_of_day_extension.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

extension DateTimeExtension on DateTime {
  /// Returns a new [DateTime] with the date part only (ignoring the time part).
  ///
  /// Example:
  /// ```dart
  /// final dateTime = DateTime(2021, 9, 7, 21, 30, 10);
  /// assert(dateTime.dateOnly == DateTime(2021, 9, 7));
  /// ```
  DateTime get dateOnly => DateTime(year, month, day);

  /// Returns a new [DateTime] replacing the time part with [timeOfDay].
  ///
  /// Example:
  /// ```
  /// final dateTime = DateTime(2021, 9, 7);
  /// const timeOfDay = TimeOfDay(hour: 21, minute: 30);
  /// assert(dateTime.addTimeOfDay(timeOfDay) == DateTime(2021, 9, 7, 21, 30));
  /// ```
  DateTime addTimeOfDay(TimeOfDay? timeOfDay) => DateTime.tryParse(
        '${DateFormat('yyyy-MM-dd').format(this)}'
        ' ${(timeOfDay ?? TimeOfDay.now()).format24Hour()}',
      )!;

  /// Whether this [DateTime] refers to the same date part as [other].
  bool isSameDateAs(DateTime other) =>
      year == other.year && month == other.month && day == other.day;

  /// Returns the first day of the week of this [DateTime].
  DateTime get firstDayOfWeek =>
      weekday == 1 ? this : subtract(Duration(days: weekday - 1));

  /// Returns a `double` representation of this [DateTime] based on the
  /// [millisecondsSinceEpoch] value.
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
