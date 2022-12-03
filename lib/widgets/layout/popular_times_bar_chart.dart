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
      padding: const EdgeInsets.symmetric(horizontal: 4),
      width: 320,
      height: 120,
      child: BarChart(
        BarChartData(
          barGroups: [
            for (final range in timeRangesOccupancy.entries)
              BarChartGroupData(
                x: range.key.hour,
                barRods: [
                  BarChartRodData(
                    toY: range.value.inMinutes.toDouble(),
                    color: range.key.hour == DateTime.now().hour
                        ? highlightColor
                        : mainColor,
                    width: 22,
                    borderRadius: const BorderRadiusDirectional.only(
                      topStart: Radius.circular(4),
                      topEnd: Radius.circular(4),
                    ).resolve(Directionality.of(context)),
                  ),
                ],
              ),
          ],
          alignment: BarChartAlignment.spaceAround,
          titlesData: FlTitlesData(
            show: true,
            leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
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
          ),
          barTouchData: BarTouchData(enabled: false),
          gridData: FlGridData(show: false),
          borderData: FlBorderData(
            show: true,
            border: Border(
              bottom: BorderSide(
                color: theme.hintColor.withOpacity(0.25),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
