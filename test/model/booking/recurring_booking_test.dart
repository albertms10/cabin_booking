import 'package:cabin_booking/model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('RecurringBooking', () {
    group('.from()', () {
      test('should create a new RecurringBooking from a JSON object', () {
        const rawRecurringBooking = {
          'id': 'booking-id',
          'cd': '1969-07-20T20:18:04.000Z',
          'md': '1969-07-20T20:18:04.000Z',
          'mc': 1,
          'sd': '2022-12-04T09:00:00.000Z',
          'ed': '2022-12-04T10:30:00.000Z',
          'de': 'Student',
          'il': false,
          'p': 1,
          're': 1,
          'red': '2023-02-04T00:00:00.000Z',
        };
        final recurringBooking = RecurringBooking.from(rawRecurringBooking);
        expect(
          recurringBooking,
          RecurringBooking(
            id: 'booking-id',
            startDate: DateTime.utc(2022, 12, 4, 9),
            endDate: DateTime.utc(2022, 12, 4, 10, 30),
            description: 'Student',
            recurringEndDate: DateTime.utc(2023, 2, 4),
          ),
        );
      });
    });

    group('.toJson()', () {
      test(
        'should return a JSON object representation of this RecurringBooking',
        () {
          const rawRecurringBooking = {
            'id': 'booking-id',
            'cd': '1969-07-20T20:18:04.000Z',
            'md': '1969-07-20T20:18:04.000Z',
            'mc': 1,
            'sd': '2022-12-04T09:00:00.000Z',
            'ed': '2022-12-04T10:30:00.000Z',
            'de': 'Student',
            'il': false,
            'p': 1,
            're': 1,
            'o': 4,
          };
          expect(
            RecurringBooking.from(rawRecurringBooking).toJson(),
            rawRecurringBooking,
          );
        },
      );
    });
  });
}
