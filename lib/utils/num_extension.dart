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
  /// assert(8.5.map(inMax: 10.0) == 0.85);
  /// assert(5.0.map(inMax: 10.0, outMin: 1.0, outMax: 4.0) == 2.5);
  /// ```
  num map({
    num inMin = 0.0,
    num inMax = 1.0,
    num outMin = 0.0,
    num outMax = 1.0,
  }) =>
      ((this - inMin) * (outMax - outMin)) / (inMax - inMin) + outMin;

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
