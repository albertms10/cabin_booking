// coverage:ignore-file

import 'package:cabin_booking/utils/date_time_extension.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart';

extension AppLocalizationsExtension on AppLocalizations {
  // Cabin.
  List<String> get cabinTerms => [cabin, 'Cab', 'C'];

  // Days.
  List<String> get relativeDays => [yesterday, today, tomorrow];

  // Time units.
  List<String> get minuteUnits => [minutes, minute, 'min', 'm'];
  List<String> get hourUnits => [hours, hour, 'h'];
  List<String> get timeUnits => [...minuteUnits, ...hourUnits];

  // Periodicity.
  List<String> get dailyPeriodicity => [everyDay, daily];
  List<String> get weeklyPeriodicity => [everyWeek, weekly];
  List<String> get monthlyPeriodicity => [everyMonth, monthly];
  List<String> get annuallyPeriodicity => [everyYear, annually];
  List<String> get periodicityTerms => [
        ...dailyPeriodicity,
        ...weeklyPeriodicity,
        ...monthlyPeriodicity,
        ...annuallyPeriodicity,
      ];

  String _formatRelativeDate(DateTime dateTime) {
    if (dateTime.isToday) return today;
    if (dateTime.isYesterday) return yesterday;
    if (dateTime.isTomorrow) return tomorrow;

    return DateFormat.yMMMEd().format(dateTime);
  }

  /// Returns a relatively formatted [String] from the given [DateTime].
  ///
  /// Example:
  /// ```dart
  /// final today = DateTime.now();
  /// assert(appLocalizations.formatRelative(today) == 'Today, 09:00');
  ///
  /// final yesterday = today.subtract(const Duration(days: 1));
  /// assert(appLocalizations.formatRelative(yesterday) == 'Yesterday, 09:00');
  /// ```
  String formatRelative(DateTime dateTime) {
    final date = _formatRelativeDate(dateTime);
    final time = DateFormat.Hm().format(dateTime);

    return [date, time].join(', ');
  }
}
