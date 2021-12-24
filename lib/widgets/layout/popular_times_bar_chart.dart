import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class PopularTimesBarChart extends StatelessWidget {
  final Map<TimeOfDay, Duration> timeRangesOccupancy;

  const PopularTimesBarChart({Key? key, required this.timeRangesOccupancy})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final mainColors = [theme.colorScheme.primary];
    final highlightColors = [theme.colorScheme.secondaryVariant];

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
              getTitles: (value) => value % 3.0 == 0 ? '${value.toInt()}' : '',
              getTextStyles: (context, value) => TextStyle(
                color: theme.hintColor,
                fontWeight: FontWeight.bold,
              ),
              margin: 8.0,
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
                    width: 22.0,
                    colors: range.key.hour == DateTime.now().hour
                        ? highlightColors
                        : mainColors,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(4.0),
                      topRight: Radius.circular(4.0),
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
