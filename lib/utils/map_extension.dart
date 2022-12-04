/// Map extension.
extension MapExtension<K, V> on Map<K, V> {
  /// Fills this [Map] with the result of [ifAbsent] for [keys] that are not
  /// present.
  ///
  /// Like [Map.update], this method mutates this [Map].
  ///
  /// Example:
  /// ```dart
  /// final map = <int, bool?>{1: true, 2: false}
  ///   ..fillEmptyKeyValues(
  ///     keys: const [0, 1, 2, 5],
  ///     ifAbsent: () => null,
  ///   );
  /// assert(map == const {0: null, 1: true, 2: false, 5: null});
  /// ```
  void fillEmptyKeyValues({
    required Iterable<K> keys,
    required V Function() ifAbsent,
  }) {
    for (final key in keys) {
      update(key, (value) => value, ifAbsent: ifAbsent);
    }
  }
}
