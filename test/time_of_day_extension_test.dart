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
  });
}
