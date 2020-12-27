import 'package:cabin_booking/utils/map_number.dart';
import 'package:flutter/material.dart';

Map<int, Color> mapColorsToHighestValue({
  @required int highestValue,
  MaterialColor color = Colors.blue,
}) {
  final colorValues = [for (var i = 2; i <= 9; i++) i * 100];

  final colorMap = <int, Color>{};

  colorMap.addAll({1: color[100]});

  for (var i = 1; i <= colorValues.length; i++) {
    final currentValue = highestValue * i ~/ colorValues.length;

    if (currentValue <= 1) continue;

    final colorValue = mapNumber(
      currentValue,
      inMax: highestValue,
      outMin: 1.0,
      outMax: colorValues.length,
    ).toInt();

    if (!colorMap.containsKey(currentValue)) {
      colorMap.addAll({currentValue: color[colorValue * 100]});
    }
  }

  return colorMap;
}
