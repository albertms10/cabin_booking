import 'package:cabin_booking/model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('SingleBooking', () {
    group('.fromJson()', () {
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
        final singleBooking = SingleBooking.fromJson(rawSingleBooking);
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
            SingleBooking.fromJson(rawSingleBooking).toJson(),
            rawSingleBooking,
          );
        },
      );
    });

    group('.copyWith()', () {
      test('should return a new copy of this SingleBooking', () {
        final booking = SingleBooking(
          startDate: DateTime(2022, 12, 4, 9),
          endDate: DateTime(2022, 12, 4, 10, 30),
          description: 'Booked slot',
          isLocked: true,
        );
        expect(booking, booking.copyWith());
        expect(identical(booking, booking.copyWith()), isFalse);
        expect(identical(booking.copyWith(), booking.copyWith()), isFalse);
      });

      test(
        'should return a new copy of this SingleBooking with overridden '
        'properties',
        () {
          final booking = SingleBooking(
            startDate: DateTime.utc(2022, 12, 4, 9),
            endDate: DateTime.utc(2022, 12, 4, 10, 30),
            description: 'Booked slot',
            isLocked: true,
          );
          final copiedBooking = booking.copyWith(
            id: 'copied-booking',
            startDate: DateTime(2023, 1, 1, 9),
            endDate: DateTime(2023, 1, 1, 10),
            description: 'John Appleseed',
            isLocked: false,
          );
          expect(copiedBooking.id, 'copied-booking');
          expect(copiedBooking.startDate, DateTime(2023, 1, 1, 9));
          expect(copiedBooking.endDate, DateTime(2023, 1, 1, 10));
          expect(copiedBooking.description, 'John Appleseed');
          expect(copiedBooking.isLocked, isFalse);
        },
      );
    });

    group('.toString()', () {
      test('should return a string representation of a SingleBooking', () {
        final booking = SingleBooking(
          startDate: DateTime(2022, 12, 4, 9),
          endDate: DateTime(2022, 12, 4, 10, 30),
          description: 'Booked slot',
        );
        expect(booking.toString(), 'Booked slot December 4, 2022 09:00–10:30');
      });

      test(
        'should return a string representation of a locked SingleBooking',
        () {
          final booking = SingleBooking(
            startDate: DateTime(2023, 1, 12, 21, 15),
            endDate: DateTime(2023, 1, 12, 22),
            description: 'Slot',
            isLocked: true,
          );
          expect(booking.toString(), '🔒 Slot January 12, 2023 21:15–22:00');
        },
      );
    });
  });
}
