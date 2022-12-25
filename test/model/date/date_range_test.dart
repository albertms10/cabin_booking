import 'package:cabin_booking/model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('DateRange', () {
    group('.fromJson()', () {
      test('should create a new DateRange from a JSON object', () {
        const rawFiniteDateRange = {
          'sd': '2022-09-11T00:00:00.000Z',
          'ed': '2023-06-23T00:00:00.000Z',
        };
        expect(
          DateRange.fromJson(rawFiniteDateRange),
          DateRange(
            startDate: DateTime.utc(2022, 9, 11),
            endDate: DateTime.utc(2023, 6, 23),
          ),
        );

        const rawStartDateRange = {'sd': '2022-09-11T00:00:00.000Z'};
        expect(
          DateRange.fromJson(rawStartDateRange),
          DateRange(startDate: DateTime.utc(2022, 9, 11)),
        );

        const rawEndDateRange = {'ed': '2023-06-23T00:00:00.000Z'};
        expect(
          DateRange.fromJson(rawEndDateRange),
          DateRange(endDate: DateTime.utc(2023, 6, 23)),
        );

        const rawInfiniteDateRange = <String, String>{};
        expect(DateRange.fromJson(rawInfiniteDateRange), DateRange.infinite);
      });
    });

    group('.toJson()', () {
      test('should return a JSON object representation of this DateRange', () {
        const rawFiniteDateRange = {
          'sd': '2022-09-11T00:00:00.000Z',
          'ed': '2023-06-23T00:00:00.000Z',
        };
        expect(
          DateRange.fromJson(rawFiniteDateRange).toJson(),
          rawFiniteDateRange,
        );

        const rawStartDateRange = {
          'sd': '2022-09-11T00:00:00.000Z',
          'ed': null,
        };
        expect(
          DateRange.fromJson(rawStartDateRange).toJson(),
          rawStartDateRange,
        );

        const rawEndDateRange = {
          'sd': null,
          'ed': '2023-06-23T00:00:00.000Z',
        };
        expect(
          DateRange.fromJson(rawEndDateRange).toJson(),
          rawEndDateRange,
        );

        const rawInfiniteDateRange = {'sd': null, 'ed': null};
        expect(
          DateRange.fromJson(rawInfiniteDateRange).toJson(),
          rawInfiniteDateRange,
        );
      });
    });

    group('.from()', () {
      test('should create a new DateRange from a DateTime', () {
        final dateTime = DateTime(2022, 12, 4, 19, 30);
        final dateRange = DateRange.from(dateTime);
        expect(dateRange.startDate, DateTime(2022, 12, 4));
        expect(dateRange.endDate, DateTime(2022, 12, 5));
      });
    });

    group('.copyWith()', () {
      test('should create a copy of this DateRange', () {
        final dateRange = DateRange.today();
        expect(dateRange, dateRange.copyWith());

        const infiniteDateRange = DateRange.infinite;
        expect(infiniteDateRange, infiniteDateRange.copyWith());
      });

      test('should create a copy of this DateRange replacing old values', () {
        final startDate = DateTime(2022, 12, 4);
        final endDate = DateTime(2022, 12, 5);
        final dateRange = DateRange(startDate: startDate, endDate: endDate);
        expect(
          dateRange,
          DateRange.infinite.copyWith(startDate: startDate, endDate: endDate),
        );
      });
    });
  });
}
