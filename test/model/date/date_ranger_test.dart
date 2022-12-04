import 'package:cabin_booking/model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('DateRanger', () {
    group('.includes()', () {
      test(
        'should return true when the DateTime is included in this DateRanger',
        () {
          final dateTime = DateTime(2022, 12, 4, 11, 30);
          final dateRange = DateRange(
            startDate: DateTime(2022, 12, 1, 9, 30),
            endDate: DateTime(2022, 12, 31, 21, 30),
          );
          expect(dateRange.includes(dateTime), isTrue);

          final startDateRange = DateRange(
            startDate: DateTime(2022, 12, 1, 9, 30),
          );
          expect(startDateRange.includes(dateTime), isTrue);

          final endDateRange = DateRange(
            endDate: DateTime(2022, 12, 31, 21, 30),
          );
          expect(endDateRange.includes(dateTime), isTrue);
        },
      );

      test(
        'should return false when the DateTime is not included in this '
        'DateRanger',
        () {
          final beforeDateTime = DateTime(2022, 12, 1, 8);
          final afterDateTime = DateTime(2022, 12, 31, 21, 45);
          final dateRange = DateRange(
            startDate: DateTime(2022, 12, 1, 9, 30),
            endDate: DateTime(2022, 12, 31, 21, 30),
          );
          expect(dateRange.includes(beforeDateTime), isFalse);
          expect(dateRange.includes(afterDateTime), isFalse);

          final startDateRange = DateRange(
            startDate: DateTime(2022, 12, 1, 9, 30),
          );
          expect(startDateRange.includes(afterDateTime), isTrue);

          final endDateRange = DateRange(
            endDate: DateTime(2022, 12, 31, 21, 30),
          );
          expect(endDateRange.includes(beforeDateTime), isTrue);
        },
      );

      test('should return true when this DateRanger is infinite', () {
        final dateTime = DateTime(2022, 12, 4, 11, 30);
        expect(DateRange.infinite.includes(dateTime), isTrue);
      });
    });

    group('.isFinite', () {
      test('should return true when this DateRanger is finite', () {
        final dateRange = DateRange(
          startDate: DateTime(2022, 12, 1, 9, 30),
          endDate: DateTime(2022, 12, 31, 21, 30),
        );
        expect(dateRange.isFinite, isTrue);
      });

      test('should return false when this DateRanger is infinite', () {
        expect(DateRange.infinite.isFinite, isFalse);

        final startDateRange = DateRange(
          startDate: DateTime(2022, 12, 1, 9, 30),
        );
        expect(startDateRange.isFinite, isFalse);

        final endDateRange = DateRange(
          endDate: DateTime(2022, 12, 31, 21, 30),
        );
        expect(endDateRange.isFinite, isFalse);
      });
    });

    group('.isInfinite', () {
      test('should return true when this DateRanger is infinite', () {
        expect(DateRange.infinite.isInfinite, isTrue);

        final startDateRange = DateRange(
          startDate: DateTime(2022, 12, 1, 9, 30),
        );
        expect(startDateRange.isInfinite, isTrue);

        final endDateRange = DateRange(
          endDate: DateTime(2022, 12, 31, 21, 30),
        );
        expect(endDateRange.isInfinite, isTrue);
      });

      test('should return false when this DateRanger is finite', () {
        final dateRange = DateRange(
          startDate: DateTime(2022, 12, 1, 9, 30),
          endDate: DateTime(2022, 12, 31, 21, 30),
        );
        expect(dateRange.isInfinite, isFalse);
      });
    });

    group('.hasInfiniteStart', () {
      test('should return true when this DateRanger has an infinite start', () {
        expect(DateRange.infinite.hasInfiniteStart, isTrue);

        final endDateRange = DateRange(
          endDate: DateTime(2022, 12, 31, 21, 30),
        );
        expect(endDateRange.hasInfiniteStart, isTrue);
      });

      test('should return false when this DateRanger has a finite start', () {
        final dateRange = DateRange(
          startDate: DateTime(2022, 12, 1, 9, 30),
          endDate: DateTime(2022, 12, 31, 21, 30),
        );
        expect(dateRange.hasInfiniteStart, isFalse);

        final startDateRange = DateRange(
          startDate: DateTime(2022, 12, 1, 9, 30),
        );
        expect(startDateRange.hasInfiniteStart, isFalse);
      });
    });

    group('.hasInfiniteEnd', () {
      test('should return true when this DateRanger has an infinite end', () {
        expect(DateRange.infinite.hasInfiniteEnd, isTrue);

        final startDateRange = DateRange(
          startDate: DateTime(2022, 12, 1, 9, 30),
        );
        expect(startDateRange.hasInfiniteEnd, isTrue);
      });

      test('should return false when this DateRanger has a finite end', () {
        final dateRange = DateRange(
          startDate: DateTime(2022, 12, 1, 9, 30),
          endDate: DateTime(2022, 12, 31, 21, 30),
        );
        expect(dateRange.hasInfiniteEnd, isFalse);

        final endDateRange = DateRange(
          endDate: DateTime(2022, 12, 31, 21, 30),
        );
        expect(endDateRange.hasInfiniteEnd, isFalse);
      });
    });

    group('.duration', () {
      test('should return the Duration of a finite DateRanger', () {
        final hourDateRange = DateRange(
          startDate: DateTime(2022, 12, 4, 9, 15),
          endDate: DateTime(2022, 12, 4, 10, 15),
        );
        expect(hourDateRange.duration, const Duration(hours: 1));

        final dayDateRange = DateRange.from(DateTime(2022, 12, 4));
        expect(dayDateRange.duration, const Duration(days: 1));

        final weekDateRange = DateRange(
          startDate: DateTime(2022, 12, 27),
          endDate: DateTime(2023, 1, 3),
        );
        expect(weekDateRange.duration, const Duration(days: 7));
      });

      test('should return a Duration of zero of an infinite DateRanger', () {
        expect(DateRange.infinite.duration, Duration.zero);

        final startDateRange = DateRange(
          startDate: DateTime(2022, 12, 1, 9, 30),
        );
        expect(startDateRange.duration, Duration.zero);

        final endDateRange = DateRange(
          endDate: DateTime(2022, 12, 31, 21, 30),
        );
        expect(endDateRange.duration, Duration.zero);
      });
    });

    group('.dateTimeList()', () {
      test('should return a DateTime list included in this DateRanger', () {
        final dateRange = DateRange.from(DateTime(2022, 12, 4));
        expect(dateRange.dateTimeList(interval: const Duration(hours: 8)), [
          DateTime(2022, 12, 4),
          DateTime(2022, 12, 4, 8),
          DateTime(2022, 12, 4, 16),
          DateTime(2022, 12, 5),
        ]);
      });

      test(
        'should return an empty DateTime list if this DateRanger is infinite',
        () {
          expect(DateRange.infinite.dateTimeList(), const <DateTime>[]);
        },
      );
    });
  });
}
