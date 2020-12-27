import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart';

class HeatMapDay extends StatelessWidget {
  final int value;
  final double size;
  final double space;
  final Map<int, Color> thresholds;
  final Color defaultColor;
  final DateTime date;

  const HeatMapDay({
    Key key,
    this.value = 0,
    this.size,
    this.space,
    this.thresholds,
    this.defaultColor = Colors.black12,
    this.date,
  })  : assert(value != null),
        super(key: key);

  /// Loop for getting the right color based on [thresholds] values
  ///
  /// If the [value] is greater than or equal one of [thresholds]' key,
  /// it will receive its value
  Color getColorFromThreshold() {
    var color = defaultColor;

    for (final threshold in thresholds.entries) {
      if (value > 0 && value >= threshold.key) color = threshold.value;
    }

    return color;
  }

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      verticalOffset: 14.0,
      message: '${AppLocalizations.of(context).nBookings(value)}'
          ' · ${DateFormat.yMMMd().format(date)}',
      child: Container(
        height: size,
        width: size,
        margin: EdgeInsets.all(space / 2),
        color: getColorFromThreshold(),
      ),
    );
  }
}
