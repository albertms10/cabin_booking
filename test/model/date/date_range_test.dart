import 'package:cabin_booking/model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('DateRange', () {
    group('.from()', () {
      test('should construct a new DateRange from a DateTime', () {
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
