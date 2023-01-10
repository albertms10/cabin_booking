import 'package:cabin_booking/model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('RecurringBooking', () {
    group('.fromJson()', () {
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
        final recurringBooking = RecurringBooking.fromJson(rawRecurringBooking);
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
        'should return a JSON object representation of this RecurringBooking '
        '(endDate method)',
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
            'red': '2023-02-04T00:00:00.000Z',
          };
          expect(
            RecurringBooking.fromJson(rawRecurringBooking).toJson(),
            rawRecurringBooking,
          );
        },
      );

      test(
        'should return a JSON object representation of this RecurringBooking '
        '(occurrences method)',
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
            RecurringBooking.fromJson(rawRecurringBooking).toJson(),
            rawRecurringBooking,
          );
        },
      );
    });

    group('.copyWith()', () {
      test('should return a new copy of this RecurringBooking', () {
        final booking = RecurringBooking(
          startDate: DateTime.utc(2022, 12, 4, 9),
          endDate: DateTime.utc(2022, 12, 4, 10, 30),
          description: 'Booked slot',
          isLocked: true,
          periodicity: Periodicity.daily,
          repeatEvery: 2,
          occurrences: 4,
        );
        expect(booking, booking.copyWith());
        expect(identical(booking, booking.copyWith()), isFalse);
        expect(identical(booking.copyWith(), booking.copyWith()), isFalse);
      });

      test(
        'should return a new copy of this RecurringBooking with overridden '
        'properties (recurringEndDate to occurrences)',
        () {
          final booking = RecurringBooking(
            startDate: DateTime(2022, 12, 4, 9),
            endDate: DateTime(2022, 12, 4, 10, 30),
            description: 'Booked slot',
            recurringEndDate: DateTime(2022, 12, 31),
          );
          final copiedBooking = booking.copyWith(
            id: 'copied-booking',
            startDate: DateTime.utc(2023, 1, 1, 9),
            endDate: DateTime.utc(2023, 1, 1, 10),
            description: 'John Appleseed',
            isLocked: true,
            periodicity: Periodicity.daily,
            repeatEvery: 3,
            occurrences: 6,
          );
          expect(copiedBooking.id, 'copied-booking');
          expect(copiedBooking.startDate, DateTime.utc(2023, 1, 1, 9));
          expect(copiedBooking.endDate, DateTime.utc(2023, 1, 1, 10));
          expect(copiedBooking.description, 'John Appleseed');
          expect(copiedBooking.isLocked, isTrue);
          expect(copiedBooking.periodicity, Periodicity.daily);
          expect(copiedBooking.repeatEvery, 3);
          expect(copiedBooking.occurrences, 6);
        },
      );

      test(
        'should return a new copy of this RecurringBooking with overridden '
        'properties (occurrences to recurringEndDate)',
        () {
          final booking = RecurringBooking(
            startDate: DateTime(2022, 12, 4, 9),
            endDate: DateTime(2022, 12, 4, 10, 30),
            description: 'Booked slot',
            occurrences: 6,
          );
          final copiedBooking = booking.copyWith(
            id: 'copied-booking',
            startDate: DateTime.utc(2023, 1, 1, 9),
            endDate: DateTime.utc(2023, 1, 1, 10),
            description: 'John Appleseed',
            isLocked: true,
            periodicity: Periodicity.daily,
            repeatEvery: 3,
            recurringEndDate: DateTime.utc(2022, 12, 31),
          );
          expect(copiedBooking.id, 'copied-booking');
          expect(copiedBooking.startDate, DateTime.utc(2023, 1, 1, 9));
          expect(copiedBooking.endDate, DateTime.utc(2023, 1, 1, 10));
          expect(copiedBooking.description, 'John Appleseed');
          expect(copiedBooking.isLocked, isTrue);
          expect(copiedBooking.periodicity, Periodicity.daily);
          expect(copiedBooking.repeatEvery, 3);
          expect(copiedBooking.recurringEndDate, DateTime.utc(2022, 12, 31));
        },
      );
    });
  });
}
