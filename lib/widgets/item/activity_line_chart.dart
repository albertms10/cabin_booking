import 'package:cabin_booking/model.dart';
import 'package:cabin_booking/utils/date_time_extension.dart';
import 'package:cabin_booking/widgets/layout/conditional_widget_wrap.dart';
import 'package:cabin_booking/widgets/layout/detail_line_chart.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class ActivityLineChart extends StatelessWidget {
  final Map<DateTime, Duration> occupiedDurationPerWeek;
  final DateRanger dateRange;
  final String? tooltipMessage;

  const ActivityLineChart({
    super.key,
    this.occupiedDurationPerWeek = const {},
    required this.dateRange,
    this.tooltipMessage,
  });

  @override
  Widget build(BuildContext context) {
    return ConditionalWidgetWrap(
      condition: tooltipMessage != null,
      conditionalBuilder: (child) {
        return Tooltip(
          message: tooltipMessage,
          child: child,
        );
      },
      child: Container(
        width: 250,
        padding: const EdgeInsets.symmetric(vertical: 24),
        child: DetailLineChart(
          minX: dateRange.startDate?.toDouble(),
          maxX: dateRange.endDate?.toDouble(),
          spots: [
            for (final entry in occupiedDurationPerWeek.entries)
              FlSpot(
                entry.key.toDouble(),
                entry.value.inMinutes.toDouble(),
              ),
          ],
        ),
      ),
    );
  }
}
