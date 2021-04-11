import 'package:cabin_booking/model/date_range.dart';
import 'package:cabin_booking/utils/datetime.dart';
import 'package:cabin_booking/utils/widgets.dart';
import 'package:cabin_booking/widgets/layout/detail_line_chart.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class ActivityLineChart extends StatelessWidget {
  final Map<DateTime, Duration> occupiedDurationPerWeek;
  final DateRange dateRange;
  final String? tooltipMessage;

  const ActivityLineChart({
    this.occupiedDurationPerWeek = const {},
    required this.dateRange,
    this.tooltipMessage,
  });

  @override
  Widget build(BuildContext context) {
    return tooltipWrap(
      tooltipMessage: tooltipMessage,
      condition: tooltipMessage != null,
      child: Container(
        width: 250.0,
        padding: const EdgeInsets.symmetric(vertical: 24.0),
        child: DetailLineChart(
          minX: dateToInt(dateRange.startDate!).toDouble(),
          maxX: dateToInt(dateRange.endDate!).toDouble(),
          spots: [
            for (final entry in occupiedDurationPerWeek.entries)
              FlSpot(
                dateToInt(entry.key).toDouble(),
                entry.value.inMinutes.toDouble(),
              ),
          ],
        ),
      ),
    )!;
  }
}
