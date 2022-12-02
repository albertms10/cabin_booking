import 'package:collection/collection.dart' show IterableNullableExtension;

/// RegExpMatch extension.
extension RegExpMatchExtension on RegExpMatch {
  /// Returns a [Map] with all non-null named groups from this [RegExpMatch].
  ///
  /// Example:
  /// ```dart
  /// final match = RegExp(r'(?<digit>\d+)(?<word>\w+)').firstMatch('12ab')!;
  /// assert(match.namedGroups == const {'digit': '12', 'word': 'ab'});
  /// ```
  Map<String, String?> get namedGroups => {
        for (final name in groupNames)
          if (namedGroup(name) != null) name: namedGroup(name),
      };

  /// Returns a list of all groups (named or indexed).
  ///
  /// The list contains the strings returned by [group] for each [groupCount]
  /// index.
  ///
  /// Example:
  /// ```dart
  /// final match = RegExp(r'(?<digit>\d+)(\w+)').firstMatch('12ab')!;
  /// assert(match.allGroups == const ['12', 'ab']);
  /// ```
  List<String> get allGroups => groups([
        for (var i = 1; i <= groupCount; i++) i,
      ]).whereNotNull().toList();
}
