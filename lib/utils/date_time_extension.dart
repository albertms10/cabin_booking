import 'package:flutter/material.dart';

/// DateTime extension.
extension DateTimeExtension on DateTime {
  /// Returns a new [DateTime] with the date part only (ignoring the time part)
  /// while keeping UTC information.
  ///
  /// Example:
  /// ```dart
  /// final dateTime = DateTime(2021, 9, 7, 21, 30, 10);
  /// assert(dateTime.dateOnly == DateTime(2021, 9, 7));
  /// ```
  DateTime get dateOnly =>
      (isUtc ? DateTime.utc : DateTime.new)(year, month, day);

  /// Returns a new [DateTime] replacing the time part with [timeOfDay].
  ///
  /// Example:
  /// ```dart
  /// final dateTime = DateTime(2021, 9, 7);
  /// const time = TimeOfDay(hour: 21, minute: 30);
  /// assert(dateTime.addLocalTimeOfDay(time) == DateTime(2021, 9, 7, 21, 30));
  /// ```
  DateTime addLocalTimeOfDay(TimeOfDay timeOfDay) {
    final dateTime =
        DateTime(year, month, day, timeOfDay.hour, timeOfDay.minute);

    return isUtc ? dateTime.toUtc() : dateTime;
  }

  /// Whether this [DateTime] occurs on the same date as [other].
  ///
  /// Example:
  /// ```dart
  /// final start = DateTime(2021, 9, 7, 21, 30, 10);
  /// final end = DateTime(2021, 9, 7, 10, 45, 40);
  /// assert(start.isSameDateAs(end));
  /// ```
  bool isSameDateAs(DateTime other) =>
      year == other.year && month == other.month && day == other.day;

  /// Returns the day of the week relative to this [DateTime].
  ///
  /// Example:
  /// ```dart
  /// final berlinWallFell = DateTime.utc(1989, 11, 9);
  /// final sunday = DateTime.utc(1989, 11, 12);
  /// assert(berlinWallFell.dayOfWeek(DateTime.sunday) == sunday);
  /// ```
  DateTime dayOfWeek(int dayOfWeek) =>
      weekday == dayOfWeek ? this : add(Duration(days: dayOfWeek - weekday));

  /// Returns the first day of the week relative to this [DateTime].
  ///
  /// Example:
  /// ```dart
  /// final berlinWallFell = DateTime.utc(1989, 11, 9);
  /// final monday = DateTime.utc(1989, 11, 6);
  /// assert(berlinWallFell.firstDayOfWeek == monday);
  /// assert(berlinWallFell.firstDayOfWeek.weekday == DateTime.monday);
  /// ```
  DateTime get firstDayOfWeek => dayOfWeek(DateTime.monday);

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
