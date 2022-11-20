import 'package:cabin_booking/utils/time_of_day_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
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

  String _formatRelativeDate(AppLocalizations appLocalizations) {
    final now = DateTime.now();
    if (isSameDateAs(now)) return appLocalizations.today;

    final yesterday = now.subtract(const Duration(days: 1));
    if (isSameDateAs(yesterday)) return appLocalizations.yesterday;

    final tomorrow = now.add(const Duration(days: 1));
    if (isSameDateAs(tomorrow)) return appLocalizations.tomorrow;

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
