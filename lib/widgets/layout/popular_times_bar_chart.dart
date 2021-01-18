import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class PopularTimesBarChart extends StatelessWidget {
  final Map<TimeOfDay, Duration> timeRangesOccupancy;

  const PopularTimesBarChart({this.timeRangesOccupancy});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final colors = [
      theme.colorScheme.primary,
    ];

    return Container(
      width: 420.0,
      height: 182.0,
      padding: const EdgeInsets.all(16.0),
      child: BarChart(
        BarChartData(
          alignment: BarChartAlignment.spaceAround,
          barTouchData: BarTouchData(enabled: false),
          titlesData: FlTitlesData(
            show: true,
            bottomTitles: SideTitles(
              showTitles: true,
              getTitles: (value) =>
                  value % 3.0 == 0 ? '${value.toInt()}' : '',
              getTextStyles: (value) => const TextStyle(
                color: Color(0xff7589a2),
                fontWeight: FontWeight.bold,
                fontSize: 14.0,
              ),
              margin: 5.0,
            ),
            leftTitles: SideTitles(showTitles: false),
          ),
          borderData: FlBorderData(show: false),
          barGroups: [
            for (final range in timeRangesOccupancy.entries)
              BarChartGroupData(
                x: range.key.hour,
                barRods: [
                  BarChartRodData(
                    y: range.value.inMinutes.toDouble(),
                    width: 20.0,
                    colors: colors,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(6.0),
                      topRight: Radius.circular(6.0),
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
