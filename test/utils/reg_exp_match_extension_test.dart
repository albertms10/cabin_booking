import 'package:cabin_booking/utils/reg_exp_match_extension.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('RegExpMatchExtension', () {
    group('.namedGroups', () {
      test('should return a Map with all named groups', () {
        final match =
            RegExp(r'(?<digit>\d+)?(?<word>\w+)?').firstMatch('12ab')!;
        expect(match.namedGroups, const {'digit': '12', 'word': 'ab'});
      });

      test('should return a Map with all non-null named groups', () {
        final match = RegExp(r'(?<digit>\d*)(?<word>\w*)?').firstMatch('12')!;
        expect(match.namedGroups, const {'digit': '12'});
      });

      test('should return a Map with empty strings on non-matched groups', () {
        final match = RegExp(r'(?<digit>\d*)(?<word>\w*)').firstMatch('12')!;
        expect(match.namedGroups, const {'digit': '12', 'word': ''});
      });

      test(
        'should return an empty Map when all matched named groups are null',
        () {
          final match =
              RegExp(r'(?<digit>\d*)?(?<word>\w*)?').firstMatch('---')!;
          expect(match.namedGroups, const {});
        },
      );

      test(
        'should return an empty Map when no named groups are specified',
        () {
          final matchNonNamed = RegExp(r'(\d+)(\w+)').firstMatch('12ab')!;
          expect(matchNonNamed.namedGroups, const {});
        },
      );
    });

    group('.allGroups', () {
      test('should return a List with all groups', () {
        final match = RegExp(r'(?<digit>\d+)?(\w+)?').firstMatch('12ab')!;
        expect(match.allGroups, const ['12', 'ab']);
      });

      test('should return a List with all non-null groups', () {
        final match = RegExp(r'(\d*)(\w*)?').firstMatch('12')!;
        expect(match.allGroups, const ['12']);
      });

      test('should return a List with empty strings on non-matched groups', () {
        final match = RegExp(r'(?<digit>\d*)(?<word>\w*)').firstMatch('12')!;
        expect(match.allGroups, const ['12', '']);
      });

      test('should return an empty Map when all matched groups are null', () {
        final match = RegExp(r'(\d*)?(\w*)?').firstMatch('---')!;
        expect(match.allGroups, const []);
      });

      test('should return an empty List when no groups are specified', () {
        final match = RegExp(r'\d+\w+').firstMatch('12ab')!;
        expect(match.allGroups, const []);
      });
    });
  });
}
