import 'package:cabin_booking/model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('DateRangeItem', () {
    group('.fromJson()', () {
      test('should create a new DateRangeItem from a JSON object', () {
        const rawFiniteDateRangeItem = {
          'id': 'date-range-item-id',
          'cd': '1969-07-20T20:18:04.000Z',
          'md': '1969-07-20T20:18:04.000Z',
          'mc': 1,
          'sd': '2022-09-11T00:00:00.000Z',
          'ed': '2023-06-23T00:00:00.000Z',
        };
        expect(
          DateRangeItem.fromJson(rawFiniteDateRangeItem),
          DateRangeItem(
            id: 'date-range-item-id',
            startDate: DateTime.utc(2022, 9, 11),
            endDate: DateTime.utc(2023, 6, 23),
          ),
        );
      });
    });

    group('.toJson()', () {
      test(
        'should return a JSON object representation of this DateRangeItem',
        () {
          const rawFiniteDateRangeItem = {
            'id': 'date-range-item-id',
            'cd': '1969-07-20T20:18:04.000Z',
            'md': '1969-07-20T20:18:04.000Z',
            'mc': 1,
            'sd': '2022-09-11T00:00:00.000Z',
            'ed': '2023-06-23T00:00:00.000Z',
          };
          expect(
            DateRangeItem.fromJson(rawFiniteDateRangeItem).toJson(),
            rawFiniteDateRangeItem,
          );
        },
      );
    });

    group('.copyWith()', () {
      test('should create a copy of this DateRangeItem', () {
        final dateRange = DateRangeItem(
          startDate: DateTime.utc(2022, 9, 11),
          endDate: DateTime.utc(2023, 6, 23),
        );
        expect(dateRange, dateRange.copyWith());
        expect(identical(dateRange, dateRange.copyWith()), isFalse);
        expect(identical(dateRange.copyWith(), dateRange.copyWith()), isFalse);
      });

      test(
        'should create a copy of this DateRangeItem replacing old values',
        () {
          final startDate = DateTime(2022, 12, 4);
          final endDate = DateTime(2022, 12, 5);
          final dateRange = DateRangeItem(
            id: 'date-range-item-id',
            startDate: startDate,
            endDate: endDate,
          );
          expect(
            dateRange,
            DateRangeItem(
              id: 'date-range-item-id',
              startDate: DateTime.utc(2022, 9, 11),
              endDate: DateTime.utc(2023, 6, 23),
            ).copyWith(startDate: startDate, endDate: endDate),
          );
        },
      );
    });

    group('.toString()', () {
      test('should return the string representation of this DateRangeItem', () {
        final dateRangeItem = DateRangeItem(
          startDate: DateTime(2022, 9, 11),
          endDate: DateTime.utc(2023, 6, 23),
        );
        expect(
          dateRangeItem.toString(),
          '2022-09-11 00:00:00.000 - 2023-06-23 00:00:00.000Z',
        );
      });
    });
  });
}
