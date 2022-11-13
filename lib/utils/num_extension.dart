extension NumExtension on num {
  /// Re-maps a number from one range to another.
  ///
  /// Defaults from 0 to 1.
  ///
  /// See [Gist by @marcschneider](https://gist.github.com/marcschneider/6991761).
  ///
  /// ---
  /// Examples:
  ///
  /// ```dart
  /// assert(8.5.map(inMax: 10) == 0.85);
  /// assert(5.map(inMax: 10, outMin: 1, outMax: 4) == 2.5);
  /// ```
  num map({num inMin = 0, num inMax = 1, num outMin = 0, num outMax = 1}) =>
      ((this - inMin) * (outMax - outMin)) / (inMax - inMin) + outMin;

  /// Returns the euclidean modulo of this number by [other]
  /// with an optional [shift] applied to this [num].
  ///
  /// ---
  /// Examples:
  ///
  /// ```dart
  /// assert(12.mod(5) == 2);
  /// assert(9.mod(5, 1) == 0);
  /// ```
  num mod(num other, [num shift = 0]) => (this + shift) % other;

  /// Returns the euclidean modulo of this number by [DateTime.daysPerWeek]
  /// with an optional [shift] applied to this [num].
  ///
  /// ---
  /// Examples:
  ///
  /// ```dart
  /// assert(7.weekdayMod() == 0);
  /// assert(8.weekdayMod(-1) == 0);
  /// ```
  num weekdayMod([num shift = 0]) => mod(DateTime.daysPerWeek, shift);

  /// Rounds this [num] rounded to the nearest [n] number.
  ///
  /// Examples:
  ///
  /// ```dart
  /// assert(17.roundToNearest(5) == 15);
  /// assert(18.roundToNearest(5) == 20);
  /// assert(30.roundToNearest(15) == 30);
  /// assert(101.roundToNearest(10) == 100);
  /// ```
  int roundToNearest(int n) => (this / n).round() * n;

  /// Pads this [num] on the left with zeros if it is shorter than 2.
  ///
  /// ---
  /// Examples:
  ///
  /// ```dart
  /// assert((-1).pad2 == '01');
  /// assert(4.pad2 == '04');
  ///
  /// assert(10.pad2 == '10');
  /// assert(500.pad2 == '500');
  /// ```
  String get padLeft2 => abs().toString().padLeft(2, '0');
}
