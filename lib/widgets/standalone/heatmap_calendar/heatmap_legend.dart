import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'heatmap_day.dart';

class HeatMapLegend extends StatelessWidget {
  final double squareSize;
  final double space;
  final MaterialColor color;
  final Color defaultColor;

  const HeatMapLegend({
    @required this.squareSize,
    @required this.space,
    this.color = Colors.blue,
    this.defaultColor = Colors.black12,
  });

  Map<int, Color> get colorThresholds => {
        1: defaultColor,
        2: color[100],
        3: color[400],
        4: color[600],
        5: color[900],
      };

  @override
  Widget build(BuildContext context) {
    final appLocalizations = AppLocalizations.of(context);

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          appLocalizations.less,
          style: Theme.of(context).textTheme.caption,
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
          appLocalizations.more,
          style: Theme.of(context).textTheme.caption,
        ),
      ],
    );
  }
}
