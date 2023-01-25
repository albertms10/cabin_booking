import 'package:cabin_booking/model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('CabinElements', () {
    group('.fromJson()', () {
      test('should create a new CabinElements from a JSON object', () {
        const rawCabinElements = {
          'p': [
            {'b': 'Yamaha', 'm': 'C5', 'ie': false},
          ],
          'l': 2,
          'c': 0,
          't': 1,
        };
        const pianos = [Piano(brand: 'Yamaha', model: 'C5')];
        expect(
          CabinElements.fromJson(rawCabinElements),
          CabinElements(pianos: pianos, lecterns: 2, tables: 1),
        );
      });
    });

    group('.toJson()', () {
      test(
        'should return a JSON object representation of this CabinElements',
        () {
          const rawCabinElements = {
            'p': [
              {'b': 'Yamaha', 'm': 'C5', 'ie': false},
            ],
            'l': 2,
            'c': 0,
            't': 1,
          };
          expect(
            CabinElements.fromJson(rawCabinElements).toJson(),
            rawCabinElements,
          );
        },
      );
    });
  });
}
