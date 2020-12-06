List<List<T>> compactizeRange<T>(
  Set<T> rangeSet, {
  T Function(T a) nextValue,
  inclusive = false,
}) {
  if (T == int) {
    nextValue ??= (a) => ((a as int) + 1) as T;
  } else {
    assert(nextValue != null);
  }

  final ranges = <List<T>>[];

  var start = rangeSet.first;
  T b;

  if (rangeSet.length > 1) {
    for (var i = 0; i < rangeSet.length - 1; i++) {
      final a = rangeSet.elementAt(i);
      b = rangeSet.elementAt(i + 1);

      if (b != nextValue(a)) {
        ranges.add([start, inclusive ? nextValue(a) : a]);
        start = b;
      }
    }
  } else {
    b = rangeSet.first;
  }

  ranges.add([start, inclusive ? nextValue(b) : b]);

  return ranges;
}
