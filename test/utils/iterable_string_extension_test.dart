import 'package:cabin_booking/utils/iterable_string_extension.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('IterableStringExtension', () {
    group('.union', () {
      test('should return a union-like joined String', () {
        expect(const ['a', 'b', 'c'].union, 'a|b|c');
      });
    });
  });
}
