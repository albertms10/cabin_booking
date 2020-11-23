import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

DateTime tryParseDateTimeWithFormattedTimeOfDay({
  DateTime dateTime,
  @required String formattedTimeOfDay,
}) =>
    DateTime.tryParse(
      DateFormat('yyyy-MM-dd').format(dateTime ?? DateTime.now()) +
          ' $formattedTimeOfDay',
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

String parsedTimeOfDayFromDateTime(DateTime dateTime) =>
    dateTime.toString().split(RegExp('[ T]'))[1];

bool isSameDay(DateTime a, DateTime b) =>
    a.year == b.year && a.month == b.month && a.day == b.day;

String _pad2(num number) => number.toString().padLeft(2, '0');

String formatTimeOfDay(TimeOfDay timeOfDay) =>
    '${_pad2(timeOfDay.hour)}:${_pad2(timeOfDay.minute)}';
