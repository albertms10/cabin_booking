import 'dart:collection';

import 'package:cabin_booking/model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('BookingCollection', () {
    group('.fromJson()', () {
      test('should create a new BookingCollection from a JSON object', () {
        const rawBookingCollection = {
          'b': [
            {
              'id': 'booking-1-id',
              'cd': '1969-07-20T20:18:04.000Z',
              'md': '1969-07-20T20:18:04.000Z',
              'mc': 1,
              'sd': '2022-12-04T09:00:00.000Z',
              'ed': '2022-12-04T10:30:00.000Z',
              'de': 'Student 1',
              'il': true,
            },
            {
              'id': 'booking-2-id',
              'cd': '1969-07-20T20:18:04.000Z',
              'md': '1969-07-20T20:18:04.000Z',
              'mc': 1,
              'sd': '2022-12-05T20:00:00.000Z',
              'ed': '2022-12-05T21:00:00.000Z',
              'de': 'Student 2',
              'il': false,
            },
          ],
          'rb': [
            {
              'id': 'recurring-booking-id',
              'cd': '1969-07-20T20:18:04.000Z',
              'md': '1969-07-20T20:18:04.000Z',
              'mc': 1,
              'sd': '2022-12-04T09:00:00.000Z',
              'ed': '2022-12-04T10:30:00.000Z',
              'de': 'Student 3',
              'il': false,
              'p': 1,
              're': 1,
              'red': '2023-02-04T00:00:00.000Z',
            },
          ],
        };
        expect(
          BookingCollection.fromJson(rawBookingCollection),
          BookingCollection(
            bookings: SplayTreeSet.of({
              SingleBooking(
                id: 'booking-1-id',
                startDate: DateTime.utc(2022, 12, 4, 9),
                endDate: DateTime.utc(2022, 12, 4, 10, 30),
                description: 'Student 1',
                isLocked: true,
              ),
              SingleBooking(
                id: 'booking-2-id',
                startDate: DateTime.utc(2022, 12, 5, 20),
                endDate: DateTime.utc(2022, 12, 5, 21),
                description: 'Student 2',
              ),
            }),
            recurringBookings: SplayTreeSet.of({
              RecurringBooking(
                id: 'recurring-booking-id',
                startDate: DateTime.utc(2022, 12, 4, 9),
                endDate: DateTime.utc(2022, 12, 4, 10, 30),
                description: 'Student 3',
                recurringEndDate: DateTime.utc(2023, 2, 4),
              ),
            }),
          ),
        );
      });
    });

    group('.toJson()', () {
      test(
        'should return a JSON object representation of this BookingCollection',
        () {
          const rawBookingCollection = {
            'b': [
              {
                'id': 'booking-1-id',
                'cd': '1969-07-20T20:18:04.000Z',
                'md': '1969-07-20T20:18:04.000Z',
                'mc': 1,
                'sd': '2022-12-04T09:00:00.000Z',
                'ed': '2022-12-04T10:30:00.000Z',
                'de': 'Student 1',
                'il': true,
              },
              {
                'id': 'booking-2-id',
                'cd': '1969-07-20T20:18:04.000Z',
                'md': '1969-07-20T20:18:04.000Z',
                'mc': 1,
                'sd': '2022-12-05T20:00:00.000Z',
                'ed': '2022-12-05T21:00:00.000Z',
                'de': 'Student 2',
                'il': false,
              },
            ],
            'rb': [
              {
                'id': 'recurring-booking-id',
                'cd': '1969-07-20T20:18:04.000Z',
                'md': '1969-07-20T20:18:04.000Z',
                'mc': 1,
                'sd': '2022-12-04T09:00:00.000Z',
                'ed': '2022-12-04T10:30:00.000Z',
                'de': 'Student 3',
                'il': false,
                'p': 1,
                're': 1,
                'red': '2023-02-04T00:00:00.000Z',
              },
            ],
          };
          expect(
            BookingCollection.fromJson(rawBookingCollection).toJson(),
            rawBookingCollection,
          );
        },
      );
    });

    group('.occupiedDuration()', () {
      test(
        'should return a Duration of zero for an empty BookingCollection',
        () {
          final emptyBookingCollection = BookingCollection();
          expect(emptyBookingCollection.occupiedDuration(), Duration.zero);
          expect(
            emptyBookingCollection.occupiedDuration(),
            Duration.zero,
          );
          expect(
            emptyBookingCollection.occupiedDuration(DateRange.today()),
            Duration.zero,
          );
        },
      );

      test('should return the occupied Duration of this BookingCollection', () {
        final bookingCollection = BookingCollection(
          bookings: SplayTreeSet.of({
            SingleBooking(
              id: 'booking-1-id',
              startDate: DateTime.utc(2022, 12, 4, 9),
              endDate: DateTime.utc(2022, 12, 4, 9, 30),
              description: 'Student 1',
              isLocked: true,
            ),
            SingleBooking(
              id: 'booking-2-id',
              startDate: DateTime.utc(2022, 12, 5, 20),
              endDate: DateTime.utc(2022, 12, 5, 21),
              description: 'Student 2',
            ),
          }),
          recurringBookings: SplayTreeSet.of({
            RecurringBooking(
              id: 'recurring-booking-id',
              startDate: DateTime.utc(2022, 12, 4, 9, 30),
              endDate: DateTime.utc(2022, 12, 4, 10, 30),
              description: 'Student 3',
              recurringEndDate: DateTime.utc(2023, 2, 4),
            ),
          }),
        );
        const totalDuration = Duration(hours: 10, minutes: 30);
        expect(bookingCollection.occupiedDuration(), totalDuration);
        expect(
          bookingCollection.occupiedDuration(
            DateRange.fromDate(DateTime.utc(2022, 12, 4)),
          ),
          const Duration(hours: 1, minutes: 30),
        );
        expect(
          bookingCollection.occupiedDuration(
            DateRange(
              startDate: DateTime.utc(2022, 12, 5, 20, 30),
              endDate: DateTime.utc(2022, 12, 5, 21),
            ),
          ),
          const Duration(minutes: 30),
        );
      });
    });

    group('.occupancyPercentOn()', () {
      test(
        'should return a zero ratio percent of occupancy for an empty '
        'BookingCollection',
        () {
          final emptyBookingCollection = BookingCollection();
          expect(emptyBookingCollection.occupancyPercentOn(), 0);
          expect(
            emptyBookingCollection.occupancyPercentOn(DateRange.today()),
            0,
          );
        },
      );

      test(
        'should return the ratio percent of occupancy of this '
        'BookingCollection',
        () {
          final bookingCollection = BookingCollection(
            bookings: SplayTreeSet.of({
              SingleBooking(
                id: 'booking-1-id',
                startDate: DateTime.utc(2022, 12, 4, 9),
                endDate: DateTime.utc(2022, 12, 4, 9, 30),
                description: 'Student 1',
                isLocked: true,
              ),
              SingleBooking(
                id: 'booking-2-id',
                startDate: DateTime.utc(2022, 12, 5, 20),
                endDate: DateTime.utc(2022, 12, 5, 21),
                description: 'Student 2',
              ),
            }),
            recurringBookings: SplayTreeSet.of({
              RecurringBooking(
                id: 'recurring-booking-id',
                startDate: DateTime.utc(2022, 12, 4, 9, 30),
                endDate: DateTime.utc(2022, 12, 4, 10, 30),
                description: 'Student 3',
                recurringEndDate: DateTime.utc(2023, 2, 4),
              ),
            }),
          );
          expect(
            bookingCollection.occupancyPercentOn(
              DateRange.fromDate(DateTime.utc(2022, 12, 4)),
            ),
            0.0625,
          );
          expect(
            bookingCollection.occupancyPercentOn(
              DateRange(
                startDate: DateTime.utc(2022, 12, 5, 20, 30),
                endDate: DateTime.utc(2022, 12, 5, 21),
              ),
            ),
            1,
          );
        },
      );
    });
  });
}
