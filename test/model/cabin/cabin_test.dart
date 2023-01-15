import 'package:cabin_booking/model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Cabin', () {
    group('.fromJson()', () {
      test('should create a new Cabin from a JSON object', () {
        const rawCabin = {
          'id': 'cabin-id',
          'cd': '1969-07-20T20:18:04.000Z',
          'md': '1969-07-20T20:18:04.000Z',
          'mc': 1,
          'n': 1,
          'e': {
            'p': [
              {'b': 'Yamaha', 'm': 'C5', 'ie': false},
            ],
            'l': 2,
            'c': 0,
            't': 1,
          },
          'b': <Map<String, dynamic>>[],
          'rb': <Map<String, dynamic>>[],
        };
        expect(
          Cabin.fromJson(rawCabin),
          Cabin(
            id: 'cabin-id',
            number: 1,
            elements: CabinElements(
              pianos: const [Piano(brand: 'Yamaha', model: 'C5')],
              lecterns: 2,
              tables: 1,
            ),
            bookingCollection: BookingCollection(
              bookings: {},
              recurringBookings: {},
            ),
          ),
        );
      });
    });

    group('.toJson()', () {
      test(
        'should return a JSON object representation of this Cabin',
        () {
          const rawCabin = {
            'id': 'cabin-id',
            'cd': '1969-07-20T20:18:04.000Z',
            'md': '1969-07-20T20:18:04.000Z',
            'mc': 1,
            'n': 1,
            'e': {
              'p': [
                {'b': 'Yamaha', 'm': 'C5', 'ie': false},
              ],
              'l': 2,
              'c': 0,
              't': 1,
            },
            'b': <Map<String, dynamic>>[],
            'rb': <Map<String, dynamic>>[],
          };
          expect(Cabin.fromJson(rawCabin).toJson(), rawCabin);
        },
      );
    });

    group('.copyWith()', () {
      test('should return a new copy of this Cabin', () {
        final cabin = Cabin(
          id: 'cabin-id',
          number: 1,
          elements: CabinElements(
            pianos: const [Piano(brand: 'Yamaha', model: 'C5')],
            lecterns: 2,
            tables: 1,
          ),
          bookingCollection: BookingCollection(
            bookings: {
              SingleBooking(id: 'booking-id'),
            },
            recurringBookings: {
              RecurringBooking(id: 'recurring-booking-id', occurrences: 1),
            },
          ),
        );
        expect(cabin, cabin.copyWith());
        expect(identical(cabin, cabin.copyWith()), isFalse);
        expect(identical(cabin.copyWith(), cabin.copyWith()), isFalse);
      });

      test(
        'should return a new copy of this Cabin with overridden '
        'properties',
        () {
          final cabin = Cabin(
            id: 'cabin-id',
            number: 1,
            elements: CabinElements(
              pianos: const [Piano(brand: 'Yamaha', model: 'C5')],
              lecterns: 2,
              tables: 1,
            ),
            bookingCollection: BookingCollection(
              bookings: {
                SingleBooking(id: 'booking-id'),
              },
              recurringBookings: {
                RecurringBooking(id: 'recurring-booking-id', occurrences: 1),
              },
            ),
          );
          final newCabinElements = CabinElements(
            pianos: const [Piano(brand: 'Bösendorfer', model: 'Imperial')],
            lecterns: 1,
            tables: 3,
          );
          final newBookingCollection = BookingCollection(
            bookings: {
              SingleBooking(id: 'booking-id-1'),
              SingleBooking(id: 'booking-id-2'),
            },
            recurringBookings: {
              RecurringBooking(id: 'recurring-booking-id-1', occurrences: 2),
            },
          );
          final copiedCabin = cabin.copyWith(
            id: 'copied-cabin',
            number: 2,
            elements: newCabinElements,
            bookingCollection: newBookingCollection,
          );
          expect(copiedCabin.id, 'copied-cabin');
          expect(copiedCabin.number, 2);
          expect(copiedCabin.elements, newCabinElements);
          expect(copiedCabin.bookingCollection, newBookingCollection);
        },
      );
    });
  });
}
