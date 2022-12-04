import 'package:cabin_booking/utils/time_of_day_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart';

/// DateTime extension.
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
  /// Defaults to [TimeOfDay.now()].
  ///
  /// Example:
  /// ```dart
  /// final dateTime = DateTime(2021, 9, 7);
  /// const timeOfDay = TimeOfDay(hour: 21, minute: 30);
  /// assert(dateTime.addTimeOfDay(timeOfDay) == DateTime(2021, 9, 7, 21, 30));
  /// ```
  DateTime addTimeOfDay([TimeOfDay? timeOfDay]) {
    timeOfDay ??= TimeOfDay.now();

    return DateTime(year, month, day, timeOfDay.hour, timeOfDay.minute);
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

  /// Returns the first day of the week of this [DateTime].
  ///
  /// Example:
  /// ```dart
  /// final berlinWallFell = DateTime.utc(1989, 11, 9);
  /// final monday = DateTime.utc(1989, 11, 6);
  /// assert(berlinWallFell.firstDayOfWeek == monday);
  /// assert(berlinWallFell.firstDayOfWeek.weekday == DateTime.monday);
  /// ```
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

  String _formatRelativeDate(AppLocalizations appLocalizations) {
    if (isToday) return appLocalizations.today;
    if (isYesterday) return appLocalizations.yesterday;
    if (isTomorrow) return appLocalizations.tomorrow;

    return DateFormat.yMMMEd().format(this);
  }

  String _formatRelativeTime() => DateFormat.Hm().format(this);

  /// Returns a relatively formatted [String] from this [DateTime].
  ///
  /// Example:
  /// ```dart
  /// final today = DateTime.now();
  /// assert(today.formatRelative(appLocalizations) == 'Today, 09:00');
  ///
  /// final yesterday = today.subtract(const Duration(days: 1));
  /// assert(yesterday.formatRelative(appLocalizations) == 'Yesterday, 09:00');
  /// ```
  String formatRelative(AppLocalizations appLocalizations) {
    final date = _formatRelativeDate(appLocalizations);
    final time = _formatRelativeTime();

    return [date, time].join(', ');
  }
}
