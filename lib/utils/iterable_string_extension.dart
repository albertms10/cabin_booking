/// Iterable String extension.
extension IterableStringExtension on Iterable<String> {
  /// Returns a union-like joined [String] from this [Iterable].
  ///
  /// Example:
  /// ```dart
  /// const list = ['a', 'b', 'c'];
  /// assert(list.union == 'a|b|c');
  /// ```
  String get union => join('|');
}
