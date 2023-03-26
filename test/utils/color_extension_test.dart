import 'package:cabin_booking/utils/color_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ColorExtension', () {
    group('.opacityThresholds()', () {
      test('should return a valid threshold to color Map', () {
        const color = Colors.blue;
        const thresholds = {
          1: Color(0x002196f3),
          4: Color(0x552196f3),
          8: Color(0xaa2196f3),
          12: Color(0xff2196f3),
        };
        expect(
          color.opacityThresholds(highestValue: 12, samples: 3),
          thresholds,
        );
      });

      test(
        'should return a valid threshold to color Map with custom minOpacity',
        () {
          const color = Colors.red;
          const thresholds = {
            1: Color(0x40f44336),
            2: Color(0x70f44336),
            4: Color(0x9ff44336),
            6: Color(0xcff44336),
            8: Color(0xfff44336),
          };
          expect(
            color.opacityThresholds(
              highestValue: 8,
              samples: 4,
              minOpacity: 0.25,
            ),
            thresholds,
          );
        },
      );

      test('should throw a RangeError if samples is not greater than zero', () {
        const color = Colors.blue;
        expect(
          () => color.opacityThresholds(highestValue: 12, samples: 0),
          throwsA(_samplesRangeErrorPredicate),
        );
        expect(
          () => color.opacityThresholds(highestValue: 12, samples: -1),
          throwsA(_samplesRangeErrorPredicate),
        );
      });

      test('should throw a RangeError if minOpacity is out of bounds', () {
        const color = Colors.blue;
        expect(
          () => color.opacityThresholds(
            highestValue: 12,
            samples: 3,
            minOpacity: -0.1,
          ),
          throwsA(_minOpacityRangeErrorPredicate),
        );
        expect(
          () => color.opacityThresholds(
            highestValue: 12,
            samples: 3,
            minOpacity: 1.01,
          ),
          throwsA(_minOpacityRangeErrorPredicate),
        );
      });
    });
  });
}

final _samplesRangeErrorPredicate =
    predicate((e) => e is RangeError && e.name == 'samples');
final _minOpacityRangeErrorPredicate =
    predicate((e) => e is RangeError && e.name == 'minOpacity');
