import 'package:cabin_booking/utils/color_extension.dart';
import 'package:cabin_booking/utils/map_int_color_extension.dart';
import 'package:flutter/material.dart';

import 'heat_map_day.dart';

class HeatMapLegend extends StatelessWidget {
  final double squareSize;
  final double space;
  final Color color;
  final int samples;
  final String? lessLabel;
  final String? moreLabel;

  const HeatMapLegend({
    super.key,
    required this.squareSize,
    required this.space,
    required this.color,
    this.samples = 5,
    this.lessLabel,
    this.moreLabel,
  }) : assert(samples > 2, 'samples must be greater than two.');

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final colorThresholds = color.opacityThresholds(
      highestValue: samples,
      samples: samples - 1,
      minOpacity: 0.2,
    );

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          lessLabel ?? 'Less',
          style: theme.textTheme.bodySmall,
        ),
        SizedBox(width: space),
        for (var threshold = 0; threshold < samples; threshold++)
          HeatMapDay(
            value: threshold,
            size: squareSize,
            padding: EdgeInsets.all(space * 0.5),
            color: colorThresholds.colorFromThreshold(threshold),
            showTooltip: false,
          ),
        SizedBox(width: space),
        Text(
          moreLabel ?? 'More',
          style: theme.textTheme.bodySmall,
        ),
      ],
    );
  }
}
