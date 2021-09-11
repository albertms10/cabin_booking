extension MapExtension<K, V> on Map<K, V> {
  Map<K, V> fillEmptyKeyValues({
    Iterable<K> keys = const [],
    required V Function() ifAbsent,
  }) {
    for (final key in keys) {
      update(key, (value) => value, ifAbsent: ifAbsent);
    }

    return this;
  }
}
