import 'package:cabin_booking/utils/num_extension.dart';
import 'package:flutter/material.dart';

extension TimeOfDayExtension on TimeOfDay {
  /// Constructs a new [TimeOfDay] instance based on [formattedString].
  ///
  /// Returns null when a [FormatException] would be thrown.
  static TimeOfDay? tryParse(String formattedString) {
    if (formattedString.isEmpty) return null;

    final particles = formattedString.split(RegExp('[:.]'));
    if (particles.length < 2) return null;

    final hour = int.tryParse(particles[0]);
    if (hour == null) return null;

    final minute = int.tryParse(particles[1]);
    if (minute == null) return null;

    return TimeOfDay(hour: hour, minute: minute);
  }

  static int compare(TimeOfDay a, TimeOfDay b) => a.compareTo(b);

  int get inMinutes => hour * TimeOfDay.minutesPerHour + minute;

  int compareTo(TimeOfDay? other) {
    if (other == null) return 1;
    if (other == this) return 0;
    return inMinutes.compareTo(other.inMinutes);
  }

  Duration durationBetween(TimeOfDay other) => Duration(
        hours: other.hour - hour,
        minutes: other.minute - minute,
      );

  String format24Hour() => '${hour.padLeft2}:${minute.padLeft2}';
}
