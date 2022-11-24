import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class PopularTimesBarChart extends StatelessWidget {
  final Map<TimeOfDay, Duration> timeRangesOccupancy;

  const PopularTimesBarChart({super.key, required this.timeRangesOccupancy});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final mainColor = theme.colorScheme.primary;
    final highlightColor = theme.colorScheme.secondaryContainer;

    return Container(
      width: 320,
      height: 120,
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: BarChart(
        BarChartData(
          alignment: BarChartAlignment.spaceAround,
          barTouchData: BarTouchData(enabled: false),
          titlesData: FlTitlesData(
            show: true,
            topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  return Text(
                    value % 3 == 0 ? '${value.toInt()}' : '',
                    style: TextStyle(
                      color: theme.hintColor,
                      fontWeight: FontWeight.bold,
                    ),
                  );
                },
              ),
            ),
            leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          ),
          gridData: FlGridData(show: false),
          borderData: FlBorderData(
            show: true,
            // TODO(albertms10): use `BorderDirectional`, https://github.com/imaNNeoFighT/fl_chart/issues/1189.
            border: Border(
              bottom: BorderSide(color: theme.hintColor.withOpacity(0.25)),
            ),
          ),
          barGroups: [
            for (final range in timeRangesOccupancy.entries)
              BarChartGroupData(
                x: range.key.hour,
                barRods: [
                  BarChartRodData(
                    toY: range.value.inMinutes.toDouble(),
                    width: 22,
                    color: range.key.hour == DateTime.now().hour
                        ? highlightColor
                        : mainColor,
                    // TODO(albertms10): use `BorderRadiusDirectional`, https://github.com/imaNNeoFighT/fl_chart/issues/1189.
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(4),
                      topRight: Radius.circular(4),
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
