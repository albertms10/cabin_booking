extension MapExtension<K, V> on Map<K, V> {
  Map<K, V> fillEmptyKeyValues({
    Iterable<K> keys = const [],
    required V Function() ifAbsent,
  }) {
    final map = Map<K, V>.of(this);

    for (final key in keys) {
      map.update(key, (value) => value, ifAbsent: ifAbsent);
    }

    return map;
  }
}
