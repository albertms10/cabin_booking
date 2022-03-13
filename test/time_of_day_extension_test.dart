import 'package:cabin_booking/utils/time_of_day_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('TimeOfDayExtension', () {
    group('.parse', () {
      test('should throw a FormatException on invalid formatted string', () {
        expect(() => TimeOfDayExtension.parse(''), throwsFormatException);
        expect(() => TimeOfDayExtension.parse('bad'), throwsFormatException);
        expect(() => TimeOfDayExtension.parse('00-00'), throwsFormatException);
        expect(() => TimeOfDayExtension.parse('0000'), throwsFormatException);
        expect(() => TimeOfDayExtension.parse('0:a'), throwsFormatException);
        expect(() => TimeOfDayExtension.parse('a.0'), throwsFormatException);
        expect(() => TimeOfDayExtension.parse('25:00'), throwsFormatException);
        expect(() => TimeOfDayExtension.parse('04:60'), throwsFormatException);
        expect(() => TimeOfDayExtension.parse('-1:30'), throwsFormatException);
      });

      test('should parse a valid formatted string', () {
        expect(
          TimeOfDayExtension.parse('00:00'),
          const TimeOfDay(hour: 0, minute: 0),
        );
        expect(
          TimeOfDayExtension.parse('1.30'),
          const TimeOfDay(hour: 1, minute: 30),
        );
        expect(
          TimeOfDayExtension.parse('21:45:15'),
          const TimeOfDay(hour: 21, minute: 45),
        );
      });
    });

    group('.tryParse', () {
      test('should throw a FormatException on invalid formatted string', () {
        expect(TimeOfDayExtension.tryParse(''), isNull);
        expect(TimeOfDayExtension.tryParse('bad'), isNull);
        expect(TimeOfDayExtension.tryParse('00-00'), isNull);
        expect(TimeOfDayExtension.tryParse('0000'), isNull);
        expect(TimeOfDayExtension.tryParse('0:a'), isNull);
        expect(TimeOfDayExtension.tryParse('a.0'), isNull);
      });

      test('should parse a valid formatted string', () {
        expect(
          TimeOfDayExtension.tryParse('00:00'),
          const TimeOfDay(hour: 0, minute: 0),
        );
        expect(
          TimeOfDayExtension.tryParse('1.30'),
          const TimeOfDay(hour: 1, minute: 30),
        );
        expect(
          TimeOfDayExtension.tryParse('21:45:15'),
          const TimeOfDay(hour: 21, minute: 45),
        );
      });
    });

    group('.increment', () {
      test('should return a TimeOfDay incremented by hours', () {
        expect(
          const TimeOfDay(hour: 10, minute: 30).increment(hours: 1),
          const TimeOfDay(hour: 11, minute: 30),
        );
        expect(
          const TimeOfDay(hour: 10, minute: 30).increment(hours: -2),
          const TimeOfDay(hour: 8, minute: 30),
        );
        expect(
          const TimeOfDay(hour: 22, minute: 30).increment(hours: 4),
          const TimeOfDay(hour: 2, minute: 30),
        );
        expect(
          const TimeOfDay(hour: 2, minute: 30).increment(hours: -5),
          const TimeOfDay(hour: 21, minute: 30),
        );
      });

      test('should return a TimeOfDay incremented by minutes', () {
        expect(
          const TimeOfDay(hour: 10, minute: 30).increment(minutes: 1),
          const TimeOfDay(hour: 10, minute: 31),
        );
        expect(
          const TimeOfDay(hour: 10, minute: 30).increment(minutes: -40),
          const TimeOfDay(hour: 9, minute: 50),
        );
        expect(
          const TimeOfDay(hour: 23, minute: 30).increment(minutes: 120),
          const TimeOfDay(hour: 1, minute: 30),
        );
        expect(
          const TimeOfDay(hour: 23, minute: 30).increment(minutes: 30),
          const TimeOfDay(hour: 0, minute: 0),
        );
      });

      test('should return a TimeOfDay incremented by hours and minutes', () {
        expect(
          const TimeOfDay(hour: 10, minute: 30).increment(hours: 1, minutes: 1),
          const TimeOfDay(hour: 11, minute: 31),
        );
        expect(
          const TimeOfDay(hour: 10, minute: 30)
              .increment(hours: -2, minutes: 40),
          const TimeOfDay(hour: 9, minute: 10),
        );
        expect(
          const TimeOfDay(hour: 23, minute: 30)
              .increment(hours: 2, minutes: -120),
          const TimeOfDay(hour: 23, minute: 30),
        );
      });
    });

    group('.durationBetween', () {
      test('should return the duration between two TimeOfDay objects', () {
        expect(
          const TimeOfDay(hour: 10, minute: 50)
              .difference(const TimeOfDay(hour: 12, minute: 20)),
          const Duration(hours: 2, minutes: 30),
        );
        expect(
          const TimeOfDay(hour: 12, minute: 00)
              .difference(const TimeOfDay(hour: 12, minute: 00)),
          Duration.zero,
        );
        expect(
          const TimeOfDay(hour: 23, minute: 00)
              .difference(const TimeOfDay(hour: 1, minute: 00)),
          const Duration(hours: 2),
        );
        expect(
          const TimeOfDay(hour: 12, minute: 00)
              .difference(const TimeOfDay(hour: 10, minute: 45)),
          const Duration(hours: 22, minutes: 45),
        );
      });
    });

    group('.format24Hour', () {
      test('should return a TimeOfDay in 24 hour format', () {
        expect(const TimeOfDay(hour: 0, minute: 0).format24Hour(), '00:00');
        expect(const TimeOfDay(hour: 9, minute: 41).format24Hour(), '09:41');
        expect(const TimeOfDay(hour: 17, minute: 45).format24Hour(), '17:45');
      });
    });

    // TODO(albertms10): remove when implemented in Flutter, https://github.com/flutter/flutter/pull/59981
    group('Comparable<TimeOfDay>', () {
      test('.compareTo', () {
        expect(
          [
            const TimeOfDay(hour: 12, minute: 0),
            const TimeOfDay(hour: 23, minute: 59),
            const TimeOfDay(hour: 0, minute: 0),
          ]..sort(TimeOfDayExtension.compare),
          [
            const TimeOfDay(hour: 0, minute: 0),
            const TimeOfDay(hour: 12, minute: 0),
            const TimeOfDay(hour: 23, minute: 59),
          ],
        );

        expect(const TimeOfDay(hour: 0, minute: 0).compareTo(null) > 0, true);

        const zero = TimeOfDay(hour: 0, minute: 0);
        expect(zero.compareTo(zero), 0);

        expect(
          const TimeOfDay(hour: 0, minute: 0)
              .compareTo(const TimeOfDay(hour: 0, minute: 0)),
          0,
        );

        expect(
          [
            const TimeOfDay(hour: 0, minute: 0),
            const TimeOfDay(hour: 23, minute: 59),
            const TimeOfDay(hour: 12, minute: 0),
          ]..sort(TimeOfDayExtension.compare),
          [
            const TimeOfDay(hour: 0, minute: 0),
            const TimeOfDay(hour: 12, minute: 0),
            const TimeOfDay(hour: 23, minute: 59),
          ],
        );
      });
    });
  });
}
