import 'package:cabin_booking/model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('SchoolYear', () {
    group('.fromJson()', () {
      test('should create a new SchoolYear from a JSON object', () {
        const rawSchoolYear = {
          'id': 'school-year-id',
          'cd': '1969-07-20T20:18:04.000Z',
          'md': '1969-07-20T20:18:04.000Z',
          'mc': 1,
          'sd': '2022-09-11T00:00:00.000Z',
          'ed': '2023-06-23T00:00:00.000Z',
          'h': [
            {
              'sd': '2022-09-11T00:00:00.000Z',
              'ed': '2022-09-12T00:00:00.000Z',
              'k': 0,
            },
            {
              'sd': '2022-12-07T00:00:00.000Z',
              'ed': '2022-12-08T00:00:00.000Z',
              'k': 1,
            },
          ],
        };
        final schoolYear = SchoolYear.fromJson(rawSchoolYear);
        expect(
          schoolYear,
          SchoolYear(
            id: 'school-year-id',
            startDate: DateTime.utc(2022, 9, 11),
            endDate: DateTime.utc(2023, 6, 23),
            holidays: {
              Holiday(
                startDate: DateTime.utc(2022, 9, 11),
                endDate: DateTime.utc(2022, 9, 12),
                kind: HolidayKind.festivity,
              ),
              Holiday(
                startDate: DateTime.utc(2022, 12, 7),
                endDate: DateTime.utc(2022, 12, 8),
                kind: HolidayKind.freeDisposal,
              ),
            },
          ),
        );
      });
    });

    group('.toJson()', () {
      test('should return a JSON object representation of this SchoolYear', () {
        const rawSchoolYear = {
          'id': 'school-year-id',
          'cd': '1969-07-20T20:18:04.000Z',
          'md': '1969-07-20T20:18:04.000Z',
          'mc': 1,
          'sd': '2022-09-11T00:00:00.000Z',
          'ed': '2023-06-23T00:00:00.000Z',
          'h': [
            {
              'sd': '2022-09-11T00:00:00.000Z',
              'ed': '2022-09-12T00:00:00.000Z',
              'k': 0,
            },
            {
              'sd': '2022-12-07T00:00:00.000Z',
              'ed': '2022-12-08T00:00:00.000Z',
              'k': 1,
            },
          ],
        };
        expect(SchoolYear.fromJson(rawSchoolYear).toJson(), rawSchoolYear);
      });
    });
  });
}
