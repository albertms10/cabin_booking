import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart';

class HeatMapDay extends StatelessWidget {
  final int value;
  final double size;
  final Map<int, Color> thresholds;
  final Color defaultColor;
  final DateTime date;
  final double opacity;
  final Duration animationDuration;
  final Color textColor;
  final FontWeight fontWeight;

  const HeatMapDay({
    Key key,
    this.value = 0,
    this.size,
    this.thresholds,
    this.defaultColor = Colors.black12,
    this.date,
    this.opacity = 0.3,
    this.animationDuration = const Duration(milliseconds: 300),
    this.textColor = Colors.black,
    this.fontWeight,
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
        alignment: Alignment.center,
        height: size,
        width: size,
        color: getColorFromThreshold(),
        margin: const EdgeInsets.all(2.0),
      ),
    );
  }
}
