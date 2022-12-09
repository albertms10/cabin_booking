import 'package:flutter/material.dart';

/// Map int to Color extension.
extension MapIntColorExtension on Map<int, Color> {
  /// Returns the corresponding [Color], if any, when the [threshold] is lower
  /// than or equal to one of this [Map] keys.
  ///
  /// The [threshold] value is expected to be a positive integer.
  ///
  /// Example:
  /// ```dart
  /// const map = {
  ///   1: Colors.red,
  ///   10: Colors.green,
  ///   20: Colors.blue,
  /// };
  /// assert(map.colorFromThreshold(1) == Colors.red);
  /// assert(map.colorFromThreshold(2) == Colors.green);
  /// assert(map.colorFromThreshold(21) == null);
  /// ```
  Color? colorFromThreshold(int threshold) {
    if (threshold <= 0) return null;

    final color = this[threshold];
    if (color != null) return color;

    for (final entry in entries) {
      if (threshold <= entry.key) return entry.value;
    }

    return null;
  }
}
