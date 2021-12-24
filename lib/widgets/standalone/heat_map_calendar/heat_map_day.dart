import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'utils/map_int_color_extension.dart';
import 'utils/time.dart';

class HeatMapDay extends StatelessWidget {
  final int value;
  final double? size;
  final double space;
  final Map<int, Color> thresholds;
  final Color defaultColor;
  final DateTime? date;
  final bool messageHidden;
  final void Function(DateTime, int)? onTap;
  final String Function(int)? valueWrapper;
  final bool highlightToday;
  final bool Function(DateTime)? highlightOn;

  const HeatMapDay({
    Key? key,
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
  }) : super(key: key);

  BoxBorder? get containerBorder {
    if (date == null) return null;

    if (highlightToday && isOnSameDay(date!, DateTime.now())) {
      return Border.all(color: Colors.orange, width: 2.0);
    }

    if (highlightOn?.call(date!) ?? false) {
      return Border.all(color: Colors.orange[200]!, width: 2.0);
    }
  }

  @override
  Widget build(BuildContext context) {
    final container = Padding(
      padding: EdgeInsets.all(space * 0.5),
      child: InkWell(
        borderRadius: const BorderRadius.all(Radius.circular(2.0)),
        onTap: date == null ? null : () => onTap?.call(date!, value),
        child: Container(
          height: size,
          width: size,
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(2.0)),
            color: thresholds.colorFromThreshold(value, defaultColor),
            border: containerBorder,
          ),
        ),
      ),
    );

    return messageHidden
        ? container
        : Tooltip(
            verticalOffset: 14.0,
            message: [
              valueWrapper?.call(value) ?? '$value',
              if (date != null) DateFormat.d().add_MMM().add_y().format(date!),
            ].join(' · '),
            child: container,
          );
  }
}
