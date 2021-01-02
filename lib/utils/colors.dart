import 'dart:collection';

import 'package:cabin_booking/utils/map_number.dart';
import 'package:flutter/material.dart';

Map<int, Color> mapColorsToHighestValue({
  @required int highestValue,
  @required Color color,
}) {
  final colorSamples = 8;

  final colorMap = SplayTreeMap<int, Color>();

  colorMap.addAll({1: color.withOpacity(0.2)});

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
