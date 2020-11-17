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

  final particles = formattedString.split(':');

  if (particles.length < 2) return null;

  int hour = int.tryParse(particles[0]);
  int minute = int.tryParse(particles[1]);

  if (hour == null || minute == null) return null;

  return TimeOfDay(hour: hour, minute: minute);
}
