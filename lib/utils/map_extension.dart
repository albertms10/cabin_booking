/// Map extension.
extension MapExtension<K, V> on Map<K, V> {
  /// Returns a new [Map] filled with the result of [ifAbsent] for [keys] that
  /// are not present in this [Map].
  ///
  /// Unlike [Map.update], this method does not mutate this [Map].
  ///
  /// Example:
  /// ```dart
  /// const map = <int, bool?>{1: true, 2: false};
  /// final filled = map.fillEmptyKeyValues(
  ///   keys: const [0, 1, 2, 5],
  ///   ifAbsent: () => null,
  /// );
  /// assert(filled == const {0: null, 1: true, 2: false, 5: null});
  /// ```
  Map<K, V> fillEmptyKeyValues({
    required Iterable<K> keys,
    required V Function() ifAbsent,
  }) {
    final map = Map<K, V>.of(this);

    for (final key in keys) {
      map.update(key, (value) => value, ifAbsent: ifAbsent);
    }

    return map;
  }
}
