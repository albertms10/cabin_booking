import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

DateTime dateOnly(DateTime dateTime) => DateTime(
      dateTime.year,
      dateTime.month,
      dateTime.day,
    );

DateTime dateTimeWithTimeOfDay({
  DateTime? dateTime,
  TimeOfDay? timeOfDay,
}) =>
    DateTime.tryParse(
      DateFormat('yyyy-MM-dd').format(dateTime ?? DateTime.now()) +
          ' ${formatTimeOfDay(timeOfDay ?? TimeOfDay.now())}',
    )!;

/// Constructs a new [TimeOfDay] instance based on [formattedString].
///
/// Returns null when a [FormatException] would be thrown.
TimeOfDay? tryParseTimeOfDay(String formattedString) {
  if (formattedString.isEmpty) return null;

  final particles = formattedString.split(RegExp('[:.]'));
  if (particles.length < 2) return null;

  final hour = int.tryParse(particles[0]);
  if (hour == null) return null;

  final minute = int.tryParse(particles[1]);
  if (minute == null) return null;

  return TimeOfDay(hour: hour, minute: minute);
}

Duration durationBetweenTimesOfDay(TimeOfDay start, TimeOfDay end) => Duration(
      hours: end.hour - start.hour,
      minutes: end.minute - start.minute,
    );

String parsedTimeOfDayFromDateTime(DateTime dateTime) =>
    dateTime.toString().split(RegExp('[ T]'))[1];

bool isSameDay(DateTime? a, DateTime? b) {
  if (a == null || b == null) return false;
  return a.year == b.year && a.month == b.month && a.day == b.day;
}

String formatTimeOfDay(TimeOfDay timeOfDay) {
  String _pad2(num number) => number.toString().padLeft(2, '0');

  final hourLabel = _pad2(timeOfDay.hour);
  final minuteLabel = _pad2(timeOfDay.minute);

  return '$hourLabel:$minuteLabel';
}

int nMod(int n, int mod, [int shift = 0]) => (n + shift) % mod;

int weekDayMod(int n, [int shift = 0]) => nMod(n, DateTime.daysPerWeek, shift);

DateTime firstWeekDate(DateTime dateTime) => dateTime.weekday == 1
    ? dateTime
    : dateTime.subtract(Duration(days: dateTime.weekday - 1));

int dateToInt(DateTime dateTime) =>
    dateTime.millisecondsSinceEpoch ~/ Duration.millisecondsPerDay;

Map<K, V> fillEmptyKeyValues<K, V>(
  Map<K, V> map, {
  Iterable<K> keys = const [],
  V Function()? ifAbsent,
}) {
  for (final key in keys) {
    map.update(key, (value) => value, ifAbsent: ifAbsent);
  }

  return map;
}

int compareTime(TimeOfDay a, TimeOfDay b) =>
    (a.hour - b.hour) * 60 + a.minute - b.minute;
