import 'package:collection/collection.dart' show IterableExtension;

extension IterableExtension<E> on Iterable<E> {
  /// Returns a filtered this Iterable excluding falsy values.
  Iterable<E> whereTruthy() =>
      whereNot((element) => const [false, 0, '', null].contains(element));

  /// Returns a list of consecutive values of this [Iterable]
  /// compacted as tuples. Consecutive values are computed
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
  ///    const [1, 2, 3, 4, 5.0, 7, 8, 9, 11].compactConsecutive() ==
  ///        const [
  ///          [1, 5],
  ///          [7, 9],
  ///          [11, 11],
  ///        ],
  ///  );
  ///
  /// assert(
  ///    'abcdfxy'.split('').compactConsecutive(inclusive: true) ==
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
  ///   input.compactConsecutive(
  ///         nextValue: (dateTime) => dateTime.add(const Duration(days: 1)),
  ///         compare: (a, b) => a.isSameDateAs(b),
  ///         inclusive: true,
  ///       ) ==
  ///       output,
  /// );
  /// ```
  Iterable<List<E>> compactConsecutive({
    E Function(E current)? nextValue,
    bool Function(E a, E b)? compare,
    bool inclusive = false,
  }) {
    if (isEmpty) return const Iterable.empty();

    if (E == num || E == int || E == double) {
      nextValue ??= (current) => (current as num) + 1 as E;
    } else if (E == String) {
      // ignore: parameter_assignments
      nextValue ??= (current) {
        final charCodes = (current as String).codeUnits.map((a) => a + 1);

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

        final nextA = nextValue(a);
        if (!(compare ??= (a, b) => a == b)(nextA, b)) {
          ranges.add([start, if (inclusive) nextA else a]);
          start = b;
        }
      }
    } else {
      b = first;
    }

    return ranges..add([start, if (inclusive) nextValue(b) else b]);
  }
}
