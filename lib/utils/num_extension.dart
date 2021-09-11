extension NumExtension on num {
  /// Re-maps a number from one range to another (default from 0 to 1).
  ///
  /// Gist: https://gist.github.com/marcschneider/6991761
  num map({
    num inMin = 0.0,
    num inMax = 1.0,
    num outMin = 0.0,
    num outMax = 1.0,
  }) =>
      ((this - inMin) * (outMax - outMin)) / (inMax - inMin) + outMin;

  String get pad2 => toString().padLeft(2, '0');
}
