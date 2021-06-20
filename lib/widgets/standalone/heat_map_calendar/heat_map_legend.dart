import 'package:flutter/material.dart';

import 'heat_map_day.dart';

class HeatMapLegend extends StatelessWidget {
  final double squareSize;
  final double space;
  final Color color;
  final Color defaultColor;
  final int samples;
  final String? lessLabel;
  final String? moreLabel;

  const HeatMapLegend({
    Key? key,
    required this.squareSize,
    required this.space,
    required this.color,
    this.defaultColor = Colors.black12,
    this.samples = 5,
    this.lessLabel,
    this.moreLabel,
  })  : assert(samples > 2),
        super(key: key);

  Map<int, Color> get colorThresholds => {
        1: defaultColor,
        for (var i = 1; i < samples - 1; i++)
          i + 1: color.withOpacity(i / (samples - 1)),
        samples: color,
      };

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          lessLabel ?? 'Less',
          style: theme.textTheme.caption,
        ),
        SizedBox(width: space),
        for (final color in colorThresholds.entries)
          HeatMapDay(
            value: color.key,
            size: squareSize,
            space: space,
            messageHidden: true,
            thresholds: colorThresholds,
          ),
        SizedBox(width: space),
        Text(
          moreLabel ?? 'More',
          style: theme.textTheme.caption,
        ),
      ],
    );
  }
}
