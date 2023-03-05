import 'package:cabin_booking/app_styles.dart';
import 'package:cabin_booking/utils/date_time_extension.dart';
import 'package:cabin_booking/widgets/layout/conditional_widget_wrap.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class HeatMapDay extends StatelessWidget {
  final int value;
  final double? size;
  final EdgeInsetsGeometry padding;
  final Color? color;
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
    this.padding = const EdgeInsets.all(2),
    this.color,
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
        padding: padding,
        child: InkWell(
          onTap: date == null ? null : () => onTap?.call(date!, value),
          borderRadius: borderRadiusSmall,
          child: Container(
            decoration: BoxDecoration(
              color: color ?? Theme.of(context).hintColor.withOpacity(0.1),
              border: containerBorder,
              borderRadius: borderRadiusSmall,
            ),
            width: size,
            height: size,
          ),
        ),
      ),
    );
  }
}
