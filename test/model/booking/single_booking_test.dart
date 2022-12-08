import 'package:cabin_booking/model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('SingleBooking', () {
    group('.from()', () {
      test('should create a new SingleBooking from a JSON object', () {
        const rawSingleBooking = {
          'id': 'booking-id',
          'cd': '1969-07-20T20:18:04.000Z',
          'md': '1969-07-20T20:18:04.000Z',
          'mc': 1,
          'sd': '2022-12-04T09:00:00.000Z',
          'ed': '2022-12-04T10:30:00.000Z',
          'de': 'Student',
          'il': true,
        };
        final singleBooking = SingleBooking.from(rawSingleBooking);
        expect(
          singleBooking,
          SingleBooking(
            id: 'booking-id',
            startDate: DateTime.utc(2022, 12, 4, 9),
            endDate: DateTime.utc(2022, 12, 4, 10, 30),
            description: 'Student',
            isLocked: true,
          ),
        );
      });
    });

    group('.toJson()', () {
      test(
        'should return a JSON object representation of this SingleBooking',
        () {
          const rawSingleBooking = {
            'id': 'booking-id',
            'cd': '1969-07-20T20:18:04.000Z',
            'md': '1969-07-20T20:18:04.000Z',
            'mc': 1,
            'sd': '2022-12-04T09:00:00.000Z',
            'ed': '2022-12-04T10:30:00.000Z',
            'de': 'Student',
            'il': false,
          };
          expect(
            SingleBooking.from(rawSingleBooking).toJson(),
            rawSingleBooking,
          );
        },
      );
    });
  });
}
