import 'package:cabin_booking/utils/num_extension.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('NumExtension', () {
    group('map', () {
      test('should re-map a number from one range to another', () {
        expect(8.5.map(inMax: 10.0), 0.85);
        expect(5.0.map(inMax: 10.0, outMin: 1.0, outMax: 4.0), 2.5);
      });
    });

    group('mod', () {
      test('should return the mod value of this int', () {
        expect(12.mod(5), 2);
      });

      test('should return the shifted mod value of this int', () {
        expect(9.mod(5, 1), 0);
      });
    });

    group('weekdayMod', () {
      test('should return the weekday mod of this int', () {
        expect(7.weekdayMod(), 0);
      });

      test('should return the shifted weekday mod of this int', () {
        expect(8.weekdayMod(-1), 0);
      });
    });

    group('padLeft2', () {
      test(
          'should return a positive fixed-length 0 left-padded string '
          'representation of this num if it is shorter than 2', () {
        expect((-1).padLeft2, '01');
        expect(4.padLeft2, '04');
      });

      test(
          'should return a positive string representation of this num '
          'if it is longer than 2', () {
        expect((-10).padLeft2, '10');
        expect(500.padLeft2, '500');
      });
    });
  });
}
