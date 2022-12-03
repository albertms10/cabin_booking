import 'package:cabin_booking/utils/string_extension.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('StringExtension', () {
    group('.tokenize', () {
      final expressions = [
        RegExp(r'(?<time>\d{1,2}[.:]\d{2})'),
        RegExp('(?<day>yesterday|today|tomorrow)', caseSensitive: false),
      ];

      test('should return a Map with all named groups', () {
        expect(
          'Today at 19:00'.tokenize(expressions),
          const {'time': '19:00', 'day': 'Today'},
        );
      });

      test('should return an empty Map when no expressions are matched', () {
        expect(
          'Think different.'.tokenize(expressions),
          const <String, String?>{},
        );
      });
    });

    group('.matchesWith', () {
      test('should return true if any matcher matches this String', () {
        expect('m'.matchesWith(['ma', 'math', '', '34']), isTrue);
        expect('mAt'.matchesWith(['MaTCH']), isTrue);
        expect('alpha'.matchesWith(['The alphabet']), isTrue);
        expect('alpha: the'.matchesWith(['The, alphabet']), isTrue);
        expect('1 3'.matchesWith(['1-3']), isTrue);
        expect('1 3 2'.matchesWith([r'1  ;·$·$2%&/( 3']), isTrue);
        expect(r'1  ;·$·$2%&/( 3'.matchesWith(['1 2 3']), isTrue);
      });

      test('should return false if the matchers do not match this String', () {
        expect('mat'.matchesWith(['', 'tree', 'mars']), isFalse);
        expect('the name is'.matchesWith(['the is']), isFalse);
      });
    });
  });
}
