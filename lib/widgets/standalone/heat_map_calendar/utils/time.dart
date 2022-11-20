import 'package:intl/intl.dart';

final List<String> monthsLabels = [
  for (var i = 1; i <= DateTime.monthsPerYear; i++)
    DateFormat.MMM().format(DateTime(2020, i)),
];

final List<String> weekDaysLabels = [
  for (var i = 1; i <= DateTime.daysPerWeek; i++)
    DateFormat.E().format(DateTime(2020, 6, i)),
];

/// Obtains the first day of the current week,
/// based on user's current day
DateTime firstDayOfTheWeek(DateTime today) {
  return safeSubtract(
    today,
    Duration(
      days: today.weekday % DateTime.daysPerWeek - 1,
      hours: today.hour,
      minutes: today.minute,
      seconds: today.second,
      milliseconds: today.millisecond,
      microseconds: today.microsecond,
    ),
  );
}

DateTime firstDayOfCalendar(DateTime day, int columnsAmount) {
  return safeSubtract(
    day,
    Duration(days: DateTime.daysPerWeek * (columnsAmount - 1)),
  );
}

/// Returns date without timezone info (UTC format).
DateTime removeTZ(DateTime dateTime) {
  return DateTime.utc(
    dateTime.year,
    dateTime.month,
    dateTime.day,
    dateTime.hour,
    dateTime.minute,
    dateTime.second,
    dateTime.millisecond,
    dateTime.microsecond,
  );
}

/// Returns date with local timezone.
DateTime addTZ(DateTime dateTime) {
  return DateTime(
    dateTime.year,
    dateTime.month,
    dateTime.day,
    dateTime.hour,
    dateTime.minute,
    dateTime.second,
    dateTime.millisecond,
    dateTime.microsecond,
  );
}

/// Subtract duration without timezone.
/// That prevents from problems with time shift if DST changed
DateTime safeSubtract(DateTime dateTime, Duration duration) {
  final add = removeTZ(dateTime).subtract(duration);

  return addTZ(add);
}

/// Add duration without timezone.
/// That prevents from problems with time shift if DST changed
DateTime safeAdd(DateTime dateTime, Duration duration) {
  final add = removeTZ(dateTime).add(duration);

  return addTZ(add);
}

/// Creates a list of [DateTime], including all days
/// between [startDate] and [finishDate]
List<DateTime> datesBetween(DateTime startDate, DateTime finishDate) {
  assert(finishDate.isAfter(startDate), 'finishDate must be after startDate.');

  final datesList = <DateTime>[];
  var aux = startDate;

  do {
    datesList.add(aux);
    aux = safeAdd(aux, const Duration(days: 1));
  } while (finishDate.millisecondsSinceEpoch >= aux.millisecondsSinceEpoch);

  return datesList;
}
