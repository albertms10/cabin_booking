import 'package:cabin_booking/utils/map_int_color_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('MapIntColorExtension', () {
    group('.colorFromThreshold()', () {
      test('should return the correct Color from a threshold', () {
        const map = {
          1: Colors.red,
          10: Colors.green,
          20: Colors.blue,
        };
        expect(map.colorFromThreshold(1), Colors.red);
        expect(map.colorFromThreshold(2), Colors.green);
        expect(map.colorFromThreshold(10), Colors.green);
        expect(map.colorFromThreshold(19), Colors.blue);
      });

      test('should return null if the threshold is out of bounds', () {
        const map = {
          1: Colors.red,
          10: Colors.green,
          20: Colors.blue,
        };
        expect(map.colorFromThreshold(0), isNull);
        expect(map.colorFromThreshold(21), isNull);
      });
    });
  });
}
