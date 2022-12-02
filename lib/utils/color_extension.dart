import 'dart:collection' show SplayTreeMap;

import 'package:cabin_booking/utils/num_extension.dart';
import 'package:flutter/material.dart';

/// Color extension.
extension ColorExtension on Color {
  /// Returns a new threshold to color Map based on the number of [samples]
  /// and up to the [highestValue] for the threshold.
  ///
  /// An optional [minOpacity] value can be provided for the first opacity
  /// value in the Map.
  ///
  /// Throws a [RangeError] if [samples] is not greater than zero.
  ///
  /// Example:
  /// ```dart
  /// const color = Colors.blue;
  /// const thresholds = {
  ///   1: Color(0x332196f3),
  ///   4: Color(0x552196f3),
  ///   8: Color(0xaa2196f3),
  ///   12: Color(0xff2196f3),
  /// };
  /// assert(
  ///   color.opacityThresholds(highestValue: 12, samples: 3) == thresholds,
  /// );
  /// ```
  Map<int, Color> opacityThresholds({
    required int highestValue,
    required int samples,
    double minOpacity = 0.2,
  }) {
    if (samples <= 0) {
      throw RangeError.range(samples, 1, null, 'samples');
    }

    final colorMap = SplayTreeMap<int, Color>.of({
      1: withOpacity(minOpacity),
    });

    for (var i = 1; i <= samples; i++) {
      final currentValue = highestValue * i ~/ samples;

      if (currentValue <= 1) continue;

      final colorValue = currentValue.map(inMax: highestValue).toDouble();

      if (!colorMap.containsKey(currentValue)) {
        colorMap.addAll({currentValue: withOpacity(colorValue)});
      }
    }

    return colorMap;
  }
}
