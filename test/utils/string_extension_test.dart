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
  });
}
