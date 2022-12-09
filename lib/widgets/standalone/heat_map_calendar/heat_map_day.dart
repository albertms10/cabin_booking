import 'package:cabin_booking/utils/date_time_extension.dart';
import 'package:cabin_booking/utils/map_int_color_extension.dart';
import 'package:cabin_booking/widgets/layout/conditional_widget_wrap.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class HeatMapDay extends StatelessWidget {
  final int value;
  final double? size;
  final double space;
  final Map<int, Color> thresholds;
  final Color defaultColor;
  final DateTime? date;
  final bool showTooltip;
  final void Function(DateTime, int)? onTap;
  final String Function(int)? valueWrapper;
  final bool highlightToday;
  final bool Function(DateTime)? highlightOn;

  const HeatMapDay({
    super.key,
    this.value = 0,
    this.size,
    this.space = 4,
    this.thresholds = const {},
    this.defaultColor = Colors.black12,
    this.date,
    this.showTooltip = true,
    this.onTap,
    this.valueWrapper,
    this.highlightToday = false,
    this.highlightOn,
  });

  BoxBorder? get containerBorder {
    if (date == null) return null;

    if (highlightToday && date!.isToday) {
      return const Border.fromBorderSide(
        BorderSide(color: Colors.orange, width: 2),
      );
    }

    if (highlightOn?.call(date!) ?? false) {
      return Border.fromBorderSide(
        BorderSide(color: Colors.orange[200]!, width: 2),
      );
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    return ConditionalWidgetWrap(
      condition: showTooltip,
      conditionalBuilder: (child) {
        return Tooltip(
          message: [
            valueWrapper?.call(value) ?? '$value',
            if (date != null) DateFormat.d().add_MMM().add_y().format(date!),
          ].join(' · '),
          verticalOffset: 14,
          child: child,
        );
      },
      child: Padding(
        padding: EdgeInsets.all(space * 0.5),
        child: InkWell(
          onTap: date == null ? null : () => onTap?.call(date!, value),
          borderRadius: const BorderRadius.all(Radius.circular(2)),
          child: Container(
            decoration: BoxDecoration(
              color: thresholds.colorFromThreshold(value) ?? defaultColor,
              border: containerBorder,
              borderRadius: const BorderRadius.all(Radius.circular(2)),
            ),
            width: size,
            height: size,
          ),
        ),
      ),
    );
  }
}
