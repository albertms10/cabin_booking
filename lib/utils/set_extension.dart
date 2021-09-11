extension SetExtension<E> on Set<E> {
  Set<List<E>> compactizeRange({
    E Function(E a)? nextValue,
    bool inclusive = false,
  }) {
    if (isEmpty) return {};

    if (E == int) {
      nextValue ??= (a) => (a as int) + 1 as E;
    } else {
      assert(nextValue != null);
    }

    final ranges = <List<E>>{};

    var start = first;
    late E b;

    if (length > 1) {
      for (var i = 0; i < length - 1; i++) {
        final a = elementAt(i);
        b = elementAt(i + 1);

        if (b != nextValue!(a)) {
          ranges.add([
            start,
            if (inclusive) nextValue(a) else a,
          ]);
          start = b;
        }
      }
    } else {
      b = first;
    }

    ranges.add([start, if (inclusive) nextValue!(b) else b]);

    return ranges;
  }
}
