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
  final bool messageHidden;

  const HeatMapDay({
    Key key,
    this.value = 0,
    this.size,
    this.space = 4.0,
    this.thresholds = const {},
    this.defaultColor = Colors.black12,
    this.date,
    this.messageHidden = false,
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
    final container = Container(
      height: size,
      width: size,
      margin: EdgeInsets.all(space / 2),
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(2.0)),
        color: getColorFromThreshold(),
      ),
    );

    return messageHidden
        ? container
        : Tooltip(
            verticalOffset: 14.0,
            message: '${AppLocalizations.of(context).nBookings(value)}'
                ' · ${DateFormat.yMMMd().format(date)}',
            child: container,
          );
  }
}
