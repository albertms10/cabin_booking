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
        const pianos = [Piano(brand: 'Yamaha', model: 'C5')];
        final cabin = Cabin.fromJson(rawCabin);
        expect(
          cabin,
          Cabin(
            id: 'cabin-id',
            number: 1,
            elements: CabinElements(
              pianos: pianos,
              lecterns: 2,
              tables: 1,
            ),
            bookings: {},
            recurringBookings: {},
          ),
        );
      });
    });

    group('.toJson()', () {
      test(
        'should return a JSON object representation of this Cabin',
        () {
          final rawCabin = {
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
  });
}
