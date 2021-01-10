import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

DateTime dateOnly(DateTime dateTime) => DateTime(
      dateTime.year,
      dateTime.month,
      dateTime.day,
    );

DateTime tryParseDateTimeWithTimeOfDay({
  DateTime dateTime,
  @required TimeOfDay timeOfDay,
}) =>
    DateTime.tryParse(
      DateFormat('yyyy-MM-dd').format(dateTime ?? DateTime.now()) +
          ' ${formatTimeOfDay(timeOfDay)}',
    );

/// Constructs a new [TimeOfDay] instance based on [formattedString].
///
/// Returns null when a [FormatException] would be thrown.
TimeOfDay tryParseTimeOfDay(String formattedString) {
  if (formattedString == null) return null;

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

bool isSameDay(DateTime a, DateTime b) =>
    a.year == b.year && a.month == b.month && a.day == b.day;

String formatTimeOfDay(TimeOfDay timeOfDay) {
  String _pad2(num number) => number.toString().padLeft(2, '0');

  final hourLabel = _pad2(timeOfDay.hour);
  final minuteLabel = _pad2(timeOfDay.minute);

  return '$hourLabel:$minuteLabel';
}

int weekDayMod(int n, [int shift = 0]) => (n + shift) % DateTime.daysPerWeek;

int dateToInt(DateTime dateTime) =>
    dateTime.millisecondsSinceEpoch ~/ Duration.millisecondsPerDay;
