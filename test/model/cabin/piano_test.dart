import 'package:cabin_booking/model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Piano', () {
    group('.fromJson()', () {
      test('should create a new Piano from a JSON object', () {
        const rawPiano = {
          'b': 'Yamaha',
          'm': 'C5',
          'ie': false,
        };
        final piano = Piano.fromJson(rawPiano);
        expect(piano, const Piano(brand: 'Yamaha', model: 'C5'));
      });
    });

    group('.toJson()', () {
      test('should return a JSON object representation of this Piano', () {
        const rawPiano = {
          'b': 'Yamaha',
          'm': 'C5',
          'ie': false,
        };
        expect(Piano.fromJson(rawPiano).toJson(), rawPiano);
      });
    });
  });
}
