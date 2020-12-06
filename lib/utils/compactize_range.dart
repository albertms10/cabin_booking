List<List<T>> compactizeRange<T>(
  Set<T> rangeSet, {
  bool Function(T a, T b) areConsecutive,
}) {
  if (T == int) {
    areConsecutive ??= (a, b) => b == (a as int) + 1;
  } else {
    assert(areConsecutive != null);
  }

  final ranges = <List<T>>[];

  var start = rangeSet.first;
  T b;

  if (rangeSet.length > 1) {
    for (var i = 0; i < rangeSet.length - 1; i++) {
      final a = rangeSet.elementAt(i);
      b = rangeSet.elementAt(i + 1);

      if (!areConsecutive(a, b)) {
        ranges.add([start, a]);
        start = b;
      }
    }
  } else {
    b = rangeSet.first;
  }

  ranges.add([start, b]);

  return ranges;
}
