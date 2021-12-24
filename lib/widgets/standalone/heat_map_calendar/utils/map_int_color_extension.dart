import 'package:flutter/material.dart';

extension MapIntColorExtension on Map<int, Color> {
  /// Returns the proper [Color] when the [threshold] is lower than or equal 
  /// one of this Map [int] keys.
  Color colorFromThreshold(
    int threshold, [
    Color defaultColor = Colors.transparent,
  ]) {
    if (threshold <= 0) return defaultColor;

    for (final entry in entries) {
      if (threshold <= entry.key) return entry.value;
    }

    return defaultColor;
  }
}
