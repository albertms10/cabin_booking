import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
}
