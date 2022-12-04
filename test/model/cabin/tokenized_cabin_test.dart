import 'package:cabin_booking/model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('TokenizedCabin', () {
    group('.fromTokens()', () {
      test('should create a new TokenizedCabin from a JSON object', () {
        const cabinTokens = {
          'cabinNumber': '1',
        };
        final tokenizedCabin = TokenizedCabin.fromTokens(cabinTokens);
        expect(tokenizedCabin, const TokenizedCabin(cabinNumber: '1'));
      });
    });

    group('.toCabin()', () {
      test('should create a new Cabin from this TokenizedCabin', () {
        const tokenizedCabin = TokenizedCabin(cabinNumber: '1');
        final cabin = Cabin(number: 1);
        expect(tokenizedCabin.toCabin().number, cabin.number);
      });
    });
  });
}
