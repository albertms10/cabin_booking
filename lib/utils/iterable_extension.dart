import 'package:collection/collection.dart' show IterableExtension;

extension IterableExtension<E> on Iterable<E> {
  /// Returns a filtered this [Iterable] excluding falsy values.
  ///
  /// Example:
  /// ```dart
  /// const list = [true, false, 0, 1, 'Hello', 'world', '', null];
  /// assert(list.whereTruthy() == const [true, 1, 'Hello', 'world']);
  /// ```
  Iterable<E> whereTruthy() =>
      whereNot(const <dynamic>[false, 0, '', null].contains);

  /// Returns a list of consecutive values of this [Iterable]
  /// compacted as tuples. Consecutive values are computed
  /// based on [nextValue], which:
  ///
  /// * if [E] is of type [num], it defaults to an increment of 1.
  /// * if [E] is of type [String], it defaults to an increment of 1
  ///   of every [String.codeUnits].
  ///
  /// Throws an [ArgumentError] if no [nextValue] is specified for types other
  /// than [num] or [String].
  ///
  /// Examples:
  /// ```dart
  /// const inputNum = [1, 2, 3, 4, 5.0, 7, 8, 9, 11];
  /// const compactedNum = [[1, 5], [7, 9], [11, 11]];
  /// assert(inputNum.compactConsecutive() == compactedNum);
  ///
  /// final inputString = 'abcdfxy'.split('');
  /// const compactedString = [['a', 'e'], ['f', 'g'], ['x', 'z']];
  /// assert(
  ///   inputString.compactConsecutive(inclusive: true) == compactedString,
  /// );
  ///
  /// final inputDateTime = [
  ///   DateTime(2021, 8, 30, 9, 30),
  ///   DateTime(2021, 8, 31),
  ///   for (var i = 1; i < 10; i++) DateTime(2021, 9, i, 21, 30),
  ///   DateTime(2021, 9, 30),
  /// ];
  ///
  /// final compactedDateTime = [
  ///   [DateTime(2021, 8, 30, 9, 30), DateTime(2021, 9, 10, 21, 30)],
  ///   [DateTime(2021, 9, 30), DateTime(2021, 10)],
  /// ];
  ///
  /// assert(
  ///   inputDateTime.compactConsecutive(
  ///         nextValue: (dateTime) => dateTime.add(const Duration(days: 1)),
  ///         compare: (a, b) => a.isSameDateAs(b),
  ///         inclusive: true,
  ///       ) ==
  ///       compactedDateTime,
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
      // False positive: the parameter has not been assigned yet.
      // ignore: parameter_assignments
      nextValue ??= (current) {
        final charCodes = (current as String).codeUnits.map((a) => a + 1);

        return String.fromCharCodes(charCodes) as E;
      };
    } else if (nextValue == null) {
      throw ArgumentError.value(
        nextValue,
        'nextValue',
        'nextValue is not specified',
      );
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
