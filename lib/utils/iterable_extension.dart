import 'package:collection/collection.dart' show IterableExtension;

extension IterableExtension<E> on Iterable<E> {
  /// Returns a filtered this Iterable excluding falsy values.
  Iterable<E> get filterFalsy =>
      whereNot((element) => const [false, 0, '', null].contains(element));

  /// Returns a compactized representation of this Iterable
  /// based on [nextValue], which:
  ///
  /// * if [E] is of type [num], it defaults to an increment of 1.
  /// * if [E] is of type [String], it defaults to an increment of 1
  ///   of every [String.codeUnits].
  ///
  /// ---
  /// Examples:
  /// ```dart
  /// assert(
  ///    const [1, 2, 3, 4, 5.0, 7, 8, 9, 11].compactizeRange() ==
  ///        const [
  ///          [1, 5],
  ///          [7, 9],
  ///          [11, 11],
  ///        ],
  ///  );
  ///
  /// assert(
  ///    'abcdfxy'.split('').compactizeRange(inclusive: true) ==
  ///        const [
  ///          ['a', 'e'],
  ///          ['f', 'g'],
  ///          ['x', 'z'],
  ///        ],
  ///  );
  ///
  /// final input = [
  ///   DateTime(2021, 8, 30, 9, 30),
  ///   DateTime(2021, 8, 31),
  ///   for (var i = 1; i < 10; i++) DateTime(2021, 9, i, 21, 30),
  ///   DateTime(2021, 9, 30),
  /// ];
  ///
  /// final output = [
  ///   [DateTime(2021, 8, 30, 9, 30), DateTime(2021, 9, 10, 21, 30)],
  ///   [DateTime(2021, 9, 30), DateTime(2021, 10)],
  /// ];
  ///
  /// assert(
  ///   input.compactizeRange(
  ///         nextValue: (dateTime) => dateTime.add(const Duration(days: 1)),
  ///         compare: (a, b) => a.isSameDateAs(b),
  ///         inclusive: true,
  ///       ) ==
  ///       output,
  /// );
  /// ```
  Iterable<List<E>> compactizeRange({
    E Function(E a)? nextValue,
    bool Function(E a, E b)? compare,
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

    var start = first;
    late E b;

    final ranges = <List<E>>{};
    if (length > 1) {
      for (var i = 0; i < length - 1; i++) {
        final a = elementAt(i);
        b = elementAt(i + 1);

        if (!(compare ??= (a, b) => a == b)(nextValue(a), b)) {
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
