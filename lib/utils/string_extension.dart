import 'package:cabin_booking/utils/reg_exp_match_extension.dart';
import 'package:collection/collection.dart';

/// String extension.
extension StringExtension on String {
  /// Returns a [Map] with all named groups that [expressions] match this
  /// [String].
  ///
  /// Example:
  /// ```dart
  /// final expressions = [
  ///   RegExp(r'(?<time>\d{1,2}[.:]\d{2})'),
  ///   RegExp('(?<day>yesterday|today|tomorrow)', caseSensitive: false),
  /// ];
  /// final tokens = 'Today at 19:00'.tokenize(expressions);
  /// assert(tokens == const {'time': '19:00', 'day': 'Today'});
  /// ```
  Map<String, String?> tokenize(Iterable<RegExp> expressions) {
    final namedGroups = <String, String?>{};

    for (final expression in expressions) {
      final matches =
          expression.allMatches(this).map((match) => match.namedGroups);

      for (final match in matches) {
        namedGroups.addAll(match);
      }
    }

    return namedGroups;
  }

  /// Returns `true` if any matcher matches this query [String].
  ///
  /// Examples:
  /// ```dart
  /// assert('mAt'.matchesWith(['MaTCH']));
  /// assert('alpha'.matchesWith(['The alphabet']));
  /// assert('1 3'.matchesWith(['1-3']));
  /// ```
  bool matchesWith(Iterable<String?> matchers) {
    final nullSafeMatchers =
        matchers.whereNotNull().map((matcher) => matcher.toLowerCase());

    return RegExp(r'[\w\d]+')
        .allMatches(toLowerCase())
        .map((match) => match[0])
        .whereNotNull()
        .every(
          (fragment) =>
              nullSafeMatchers.any((matcher) => matcher.contains(fragment)),
        );
  }
}
