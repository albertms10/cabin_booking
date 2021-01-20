import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'time_utils.dart';

class HeatMapDay extends StatelessWidget {
  final int value;
  final double size;
  final double space;
  final Map<int, Color> thresholds;
  final Color defaultColor;
  final DateTime date;
  final bool messageHidden;
  final void Function(DateTime, int) onTap;
  final String Function(int) valueWrapper;
  final bool highlightToday;
  final bool Function(DateTime) highlightOn;

  const HeatMapDay({
    Key key,
    this.value = 0,
    this.size,
    this.space = 4.0,
    this.thresholds = const {},
    this.defaultColor = Colors.black12,
    this.date,
    this.messageHidden = false,
    this.onTap,
    this.valueWrapper,
    this.highlightToday = false,
    this.highlightOn,
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
    final container = Padding(
      padding: EdgeInsets.all(space / 2.0),
      child: InkWell(
        borderRadius: const BorderRadius.all(Radius.circular(2.0)),
        onTap: onTap == null ? null : () => onTap(date, value),
        child: Container(
          height: size,
          width: size,
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(2.0)),
            color: getColorFromThreshold(),
            border:
                highlightToday && TimeUtils.isOnSameDay(date, DateTime.now())
                    ? Border.all(color: Colors.orange, width: 2.0)
                    : highlightOn != null && highlightOn(date)
                        ? Border.all(color: Colors.orange[200], width: 2.0)
                        : null,
          ),
        ),
      ),
    );

    return messageHidden
        ? container
        : Tooltip(
            verticalOffset: 14.0,
            message: '${(valueWrapper?.call(value) ?? value)}'
                ' · ${DateFormat.d().add_MMM().add_y().format(date)}',
            child: container,
          );
  }
}
