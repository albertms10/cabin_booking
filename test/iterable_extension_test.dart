import 'package:cabin_booking/utils/date_time_extension.dart';
import 'package:cabin_booking/utils/iterable_extension.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('IterableExtension', () {
    group('.filterFalsy', () {
      test('should return this Iterable excluding falsy values', () {
        expect(
          const [true, false, 0, 1, 'Hello', 'world', '', null].filterFalsy,
          const [true, 1, 'Hello', 'world'],
        );
      });
    });

    group('.compactizeRange', () {
      test('should return an empty Iterable', () {
        expect(const [].compactizeRange(), const []);
      });

      test('should return one range pair', () {
        expect(
          const [1].compactizeRange(),
          const [
            [1, 1],
          ],
        );
      });

      test('should return one range pair, inclusive', () {
        expect(
          const [1].compactizeRange(inclusive: true),
          const [
            [1, 2],
          ],
        );
      });

      test('should return a compactized Iterable<num>', () {
        expect(
          const [1, 2, 3, 4, 5.0, 7, 8, 9, 11].compactizeRange(),
          const [
            [1, 5],
            [7, 9],
            [11, 11],
          ],
        );
      });

      test('should return an inclusive compactized Iterable<num>', () {
        expect(
          const [1, 2, 3, 4, 5.0, 7, 8, 9, 11].compactizeRange(inclusive: true),
          const [
            [1, 6],
            [7, 10],
            [11, 12],
          ],
        );
      });

      test('should return a compactized Iterable<String>', () {
        expect(
          'abcdfxy'.split('').compactizeRange(),
          const [
            ['a', 'd'],
            ['f', 'f'],
            ['x', 'y'],
          ],
        );
      });

      test('should return an inclusive compactized Iterable<String>', () {
        expect(
          'abcdfxy'.split('').compactizeRange(inclusive: true),
          const [
            ['a', 'e'],
            ['f', 'g'],
            ['x', 'z'],
          ],
        );
      });

      test(
          'should return an inclusive compactized Iterable<DateTime> '
          'providing a custom nextValue and compare callbacks', () {
        expect(
          [
            DateTime(2021, 8, 30, 9, 30),
            DateTime(2021, 8, 31),
            for (var i = 1; i < 10; i++) DateTime(2021, 9, i, 21, 30),
            DateTime(2021, 9, 30),
          ].compactizeRange(
            nextValue: (dateTime) => dateTime.add(const Duration(days: 1)),
            compare: (a, b) => a.isSameDateAs(b),
            inclusive: true,
          ),
          [
            [DateTime(2021, 8, 30, 9, 30), DateTime(2021, 9, 10, 21, 30)],
            [DateTime(2021, 9, 30), DateTime(2021, 10)],
          ],
        );
      });
    });
  });
}
