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

    group('.compactConsecutive', () {
      test('should throw an ArgumentError', () {
        expect(() => const [true].compactConsecutive(), throwsArgumentError);
        expect(() => [() {}].compactConsecutive(), throwsArgumentError);
        expect(() => [[]].compactConsecutive(), throwsArgumentError);
        expect(
          () => [
            {''},
          ].compactConsecutive(),
          throwsArgumentError,
        );
        expect(
          () => [
            {'': ''},
          ].compactConsecutive(),
          throwsArgumentError,
        );
      });

      test('should return an empty Iterable', () {
        expect(const [].compactConsecutive(), const []);
      });

      test('should return one range pair', () {
        expect(
          const [1].compactConsecutive(),
          const [
            [1, 1],
          ],
        );
      });

      test('should return one range pair, inclusive', () {
        expect(
          const [1].compactConsecutive(inclusive: true),
          const [
            [1, 2],
          ],
        );
      });

      test('should return a compacted Iterable<num>', () {
        expect(
          const [1, 2, 3, 4, 5.0, 7, 8, 9, 11].compactConsecutive(),
          const [
            [1, 5],
            [7, 9],
            [11, 11],
          ],
        );
      });

      test('should return an inclusive compacted Iterable<num>', () {
        expect(
          const [1, 2, 3, 4, 5.0, 7, 8, 9, 11]
              .compactConsecutive(inclusive: true),
          const [
            [1, 6],
            [7, 10],
            [11, 12],
          ],
        );
      });

      test('should return a compacted Iterable<String>', () {
        expect(
          'abcdfxy'.split('').compactConsecutive(),
          const [
            ['a', 'd'],
            ['f', 'f'],
            ['x', 'y'],
          ],
        );
      });

      test('should return an inclusive compacted Iterable<String>', () {
        expect(
          'abcdfxy'.split('').compactConsecutive(inclusive: true),
          const [
            ['a', 'e'],
            ['f', 'g'],
            ['x', 'z'],
          ],
        );
      });

      test(
        'should return an inclusive compacted Iterable<DateTime> '
        'providing a custom nextValue and compare callbacks',
        () {
          expect(
            [
              DateTime(2021, 8, 30, 9, 30),
              DateTime(2021, 8, 31),
              for (var i = 1; i < 10; i++) DateTime(2021, 9, i, 21, 30),
              DateTime(2021, 9, 30),
            ].compactConsecutive(
              nextValue: (dateTime) => dateTime.add(const Duration(days: 1)),
              compare: (a, b) => a.isSameDateAs(b),
              inclusive: true,
            ),
            [
              [DateTime(2021, 8, 30, 9, 30), DateTime(2021, 9, 10, 21, 30)],
              [DateTime(2021, 9, 30), DateTime(2021, 10)],
            ],
          );
        },
      );
    });
  });
}
