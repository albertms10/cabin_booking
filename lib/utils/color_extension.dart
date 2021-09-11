import 'dart:collection' show SplayTreeMap;

import 'package:cabin_booking/utils/num_extension.dart';
import 'package:flutter/material.dart';

extension ColorExtension on Color {
  Map<int, Color> opacityThresholds({
    required int highestValue,
    required int samples,
    double minOpacity = 0.2,
  }) {
    assert(samples > 0);

    final colorMap = SplayTreeMap<int, Color>.from({
      1: withOpacity(minOpacity),
    });

    for (var i = 1; i <= samples; i++) {
      final currentValue = highestValue * i ~/ samples;

      if (currentValue <= 1) continue;

      final colorValue = currentValue.map(inMax: highestValue);

      if (!colorMap.containsKey(currentValue)) {
        colorMap.addAll({currentValue: withOpacity(colorValue)});
      }
    }

    return colorMap;
  }
}
