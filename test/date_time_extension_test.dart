import 'package:cabin_booking/utils/date_time_extension.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('isSameDateAs', () {
    test('should return true when the dates are the same', () {
      expect(
        DateTime(2021, 9, 7, 21, 30, 10)
            .isSameDateAs(DateTime(2021, 9, 7, 10, 45, 40)),
        isTrue,
      );
    });

    test('should return false when the dates are not the same', () {
      expect(
        DateTime(2021, 1, 10, 9, 30).isSameDateAs(DateTime(2021, 2, 10, 9, 30)),
        isFalse,
      );
    });
  });
}
