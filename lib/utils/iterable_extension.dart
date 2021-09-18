import 'package:collection/collection.dart' show IterableExtension;

extension IterableExtension<E> on Iterable<E> {
  Iterable<E> get filterFalsy =>
      whereNot((element) => const [false, 0, '', null].contains(element));

  /// Returns a compactized representation of this Iterable
  /// based on [nextValue], which:
  ///
  /// * if [E] is of type [num], it defaults to an increment of 1.
  /// * if [E] is of type [String], it defaults to an increment of 1
  ///   of every [String.codeUnits].
  Iterable<List<E>> compactizeRange({
    E Function(E)? nextValue,
    bool inclusive = false,
  }) {
    if (isEmpty) return const Iterable.empty();

    if (E == num) {
      nextValue ??= (a) => (a as num) + 1 as E;
    } else if (E == String) {
      nextValue ??= (a) {
        final charCodes = (a as String).codeUnits.map((a) => a + 1);
        return String.fromCharCodes(charCodes) as E;
      };
    } else if (nextValue == null) {
      throw ArgumentError('Specify the nextValue callback');
    }

    final ranges = <List<E>>{};

    var start = first;
    late E b;

    if (length > 1) {
      for (var i = 0; i < length - 1; i++) {
        final a = elementAt(i);
        b = elementAt(i + 1);

        if (b != nextValue(a)) {
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

    return ranges..add([start, if (inclusive) nextValue(b) else b]);
  }
}
