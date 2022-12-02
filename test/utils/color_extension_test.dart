import 'package:cabin_booking/utils/color_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ColorExtension', () {
    group('.opacityThresholds', () {
      test('should return a valid threshold to color Map', () {
        const color = Colors.blue;
        const thresholds = {
          1: Color(0x332196f3),
          4: Color(0x552196f3),
          8: Color(0xaa2196f3),
          12: Color(0xff2196f3),
        };
        expect(
          color.opacityThresholds(highestValue: 12, samples: 3),
          thresholds,
        );
      });

      test('should throw a RangeError if samples is not greater than zero', () {
        const color = Colors.blue;
        expect(
          () => color.opacityThresholds(highestValue: 12, samples: -1),
          throwsRangeError,
        );
      });
    });
  });
}
