import 'package:cabin_booking/model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Holiday', () {
    group('.from()', () {
      test('should create a new Holiday from a JSON object', () {
        const rawHoliday = {
          'id': 'holiday-id',
          'cd': '1969-07-20T20:18:04.000Z',
          'md': '1969-07-20T20:18:04.000Z',
          'mc': 1,
          'sd': '2022-09-11T00:00:00.000Z',
          'ed': '2022-09-12T00:00:00.000Z',
          'k': 0,
        };
        final holiday = Holiday.from(rawHoliday);
        final h = Holiday(
          id: 'holiday-id',
          startDate: DateTime.utc(2022, 9, 11),
          endDate: DateTime.utc(2022, 9, 12),
        );

        expect(holiday, h);
      });
    });

    group('.toJson()', () {
      test('should return a JSON object representation of this Holiday', () {
        const rawHoliday = {
          'id': 'holiday-id',
          'cd': '1969-07-20T20:18:04.000Z',
          'md': '1969-07-20T20:18:04.000Z',
          'mc': 1,
          'sd': '2022-10-31T00:00:00.000Z',
          'ed': '2022-11-01T00:00:00.000Z',
          'k': 1,
        };
        expect(Holiday.from(rawHoliday).toJson(), rawHoliday);
      });
    });
  });
}
