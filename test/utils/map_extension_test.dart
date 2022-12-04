import 'package:cabin_booking/utils/map_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('MapExtension', () {
    group('.fillEmptyKeyValues()', () {
      test('should return the same Map when no keys are provided', () {
        const map = <int, bool?>{1: true, 2: true};
        final filled = Map.of(map)
          ..fillEmptyKeyValues(
            keys: const [],
            ifAbsent: () => null,
          );
        expect(filled, map);
      });

      test('should return the same Map when all keys are already present', () {
        const map = <int, bool?>{1: true, 2: true};
        final filled = Map.of(map)
          ..fillEmptyKeyValues(
            keys: const [1, 2],
            ifAbsent: () => null,
          );
        expect(filled, map);
      });

      test('should return a filled int to bool? Map', () {
        const map = <int, bool?>{2: true, 4: false};
        final filled = Map.of(map)
          ..fillEmptyKeyValues(
            keys: const [0, 1, 2, 3, 4, 5],
            ifAbsent: () => null,
          );
        expect(filled, {
          0: null,
          1: null,
          2: true,
          3: null,
          4: false,
          5: null,
        });
      });

      test('should return a filled TimeOfDay to Duration Map', () {
        final map = <TimeOfDay, Duration>{
          const TimeOfDay(hour: 9, minute: 0): const Duration(minutes: 30),
          const TimeOfDay(hour: 11, minute: 0): const Duration(minutes: 45),
        };
        final filled = Map.of(map)
          ..fillEmptyKeyValues(
            keys: [
              for (var i = 9; i <= 12; i++) TimeOfDay(hour: i, minute: 0),
            ],
            ifAbsent: () => Duration.zero,
          );
        expect(filled, {
          const TimeOfDay(hour: 9, minute: 0): const Duration(minutes: 30),
          const TimeOfDay(hour: 10, minute: 0): Duration.zero,
          const TimeOfDay(hour: 11, minute: 0): const Duration(minutes: 45),
          const TimeOfDay(hour: 12, minute: 0): Duration.zero,
        });
      });
    });
  });
}
