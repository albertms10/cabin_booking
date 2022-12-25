import 'package:cabin_booking/model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Holiday', () {
    group('.from()', () {
      test('should create a new Holiday from a JSON object', () {
        const rawHoliday = {
          'sd': '2022-09-11T00:00:00.000Z',
          'ed': '2022-09-12T00:00:00.000Z',
          'k': 0,
        };
        final holiday = Holiday.from(rawHoliday);
        expect(
          holiday,
          Holiday(
            startDate: DateTime.utc(2022, 9, 11),
            endDate: DateTime.utc(2022, 9, 12),
            kind: HolidayKind.festivity,
          ),
        );
      });
    });

    group('.toJson()', () {
      test('should return a JSON object representation of this Holiday', () {
        const rawHoliday = {
          'sd': '2022-10-31T00:00:00.000Z',
          'ed': '2022-11-01T00:00:00.000Z',
          'k': 1,
        };
        expect(Holiday.from(rawHoliday).toJson(), rawHoliday);
      });
    });
  });
}
