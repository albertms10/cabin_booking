import 'dart:collection';

import 'package:cabin_booking/utils/map_number.dart';
import 'package:flutter/material.dart';

Map<int, Color> mapColorsToHighestValue({
  required int highestValue,
  required Color color,
  required int colorSamples,
  double minOpacity = 0.2,
}) {
  assert(colorSamples > 0);

  final colorMap = SplayTreeMap<int, Color>();

  colorMap.addAll({1: color.withOpacity(minOpacity)});

  for (var i = 1; i <= colorSamples; i++) {
    final currentValue = highestValue * i ~/ colorSamples;

    if (currentValue <= 1) continue;

    final colorValue = mapNumber(currentValue, inMax: highestValue);

    if (!colorMap.containsKey(currentValue)) {
      colorMap.addAll({currentValue: color.withOpacity(colorValue)});
    }
  }

  return colorMap;
}
