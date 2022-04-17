extension IterableStringExtension on Iterable<String> {
  /// Returns a union-like joined [String] from this [Iterable].
  ///
  /// Example:
  /// ```dart
  /// assert(const ['a', 'b', 'c'].union == 'a|b|c');
  /// ```
  String get union => join('|');
}
