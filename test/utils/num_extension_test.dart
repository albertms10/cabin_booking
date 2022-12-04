import 'package:cabin_booking/utils/num_extension.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('NumExtension', () {
    group('.map()', () {
      test('should re-map a number from one range to another', () {
        expect(8.5.map(inMax: 10), 0.85);
        expect(5.map(inMax: 10, outMin: 1, outMax: 4), 2.5);
      });
    });

    group('.mod()', () {
      test('should return the mod value of this int', () {
        expect(12.mod(5), 2);
      });

      test('should return the shifted mod value of this int', () {
        expect(9.mod(5, 1), 0);
      });
    });

    group('.weekdayMod()', () {
      test('should return the weekday mod of this int', () {
        expect(7.weekdayMod(), 0);
      });

      test('should return the shifted weekday mod of this int', () {
        expect(8.weekdayMod(-1), 0);
      });
    });

    group('.roundToNearest()', () {
      test('should round this num to the nearest n number.', () {
        expect(17.roundToNearest(5), 15);
        expect(18.roundToNearest(5), 20);
        expect(30.roundToNearest(10), 30);
        expect(101.roundToNearest(10), 100);
      });
    });

    group('.padLeft2', () {
      test(
        'should pad this [num] on the left with zeros '
        'if it is shorter than 2.',
        () {
          expect((-1).padLeft2, '01');
          expect(4.padLeft2, '04');
        },
      );

      test(
        'should return a string representation of this num '
        'if it is longer than or equal to 2',
        () {
          expect((-10).padLeft2, '10');
          expect(500.padLeft2, '500');
        },
      );
    });
  });
}
