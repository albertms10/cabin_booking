import 'package:cabin_booking/utils/num_extension.dart';
import 'package:flutter/material.dart';

extension TimeOfDayExtension on TimeOfDay {
  /// Constructs a new [TimeOfDay] instance based on [formattedString].
  ///
  /// Throws a [FormatException] if the input string cannot be parsed.
  ///
  /// The [formattedString] must be a valid non-empty expression of integer
  /// hours (0..23) and minutes (0..59), separated with ':' or '.'.
  ///
  /// Instead of throwing and immediately catching the [FormatException],
  /// instead use [tryParse] to handle a parsing error.
  /// Example:
  /// ```dart
  /// final value = TimeOfDayExtension.tryParse(formattedString);
  /// if (value == null) ... handle the problem
  /// ```
  static TimeOfDay parse(String formattedString) {
    final particles = formattedString.split(RegExp('[:.]'));
    if (particles.length < 2) {
      throw FormatException('Invalid time format', formattedString);
    }

    final hour = int.parse(particles.first);
    final minute = int.parse(particles[1]);

    if ((hour >= 0 && hour < TimeOfDay.hoursPerDay) &&
        (minute >= 0 && minute < TimeOfDay.minutesPerHour)) {
      return TimeOfDay(hour: hour, minute: minute);
    }

    throw FormatException('Time out of range', formattedString);
  }

  /// Constructs a new [TimeOfDay] instance based on [formattedString].
  ///
  /// Works like [parse] except that this function returns `null` where [parse]
  /// would throw a [FormatException].
  static TimeOfDay? tryParse(String formattedString) {
    try {
      return parse(formattedString);
    } on FormatException {
      return null;
    }
  }

  /// Returns a [Duration] with the difference when subtracting [other] from
  /// this [TimeOfDay].
  Duration difference(TimeOfDay other) => Duration(
        hours: (other.hour - hour) % TimeOfDay.hoursPerDay,
        minutes: (other.minute - minute) % TimeOfDay.minutesPerHour,
      );

  /// Returns the 24-hour formatted string representation of this [TimeOfDay],
  /// separated with ':'.
  String format24Hour() => '${hour.padLeft2}:${minute.padLeft2}';

  // TODO(albertms10): remove when implemented in Flutter, https://github.com/flutter/flutter/pull/59981
  static int compare(TimeOfDay a, TimeOfDay b) => a.compareTo(b);

  int get inMinutes => hour * TimeOfDay.minutesPerHour + minute;

  int compareTo(TimeOfDay? other) {
    if (other == null) return 1;
    if (other == this) return 0;

    return inMinutes.compareTo(other.inMinutes);
  }
}
