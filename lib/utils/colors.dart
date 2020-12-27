import 'package:cabin_booking/utils/map_number.dart';
import 'package:flutter/material.dart';

Map<int, Color> mapColorsToHighestValue({
  @required int highestValue,
  MaterialColor color = Colors.blue,
}) {
  final colorValues = [for (var i = 1; i <= 9; i++) i * 100];

  final colorMap = <int, Color>{};

  if (highestValue ~/ colorValues.length > 1) {
    colorMap.addAll({1: color[50]});
  }

  for (var i = 1; i <= colorValues.length; i++) {
    final currentValue = highestValue * i ~/ colorValues.length;

    final colorValue = mapNumber(
      currentValue,
      inMax: highestValue,
      outMax: colorValues.length,
    ).toInt();

    if (!colorMap.containsKey(currentValue)) {
      colorMap.addAll({currentValue: color[colorValue * 100]});
    }
  }

  return colorMap;
}
