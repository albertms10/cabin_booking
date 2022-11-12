import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class DetailLineChart extends StatelessWidget {
  final List<FlSpot> spots;
  final double? minX;
  final double? maxX;
  final double minY;
  final double? maxY;

  const DetailLineChart({
    super.key,
    required this.spots,
    this.minX,
    this.maxX,
    this.minY = 0.0,
    this.maxY,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = theme.colorScheme.primary;

    return LineChart(
      LineChartData(
        minX: minX,
        maxX: maxX,
        minY: minY,
        maxY: maxY,
        gridData: FlGridData(show: false),
        titlesData: FlTitlesData(show: false),
        borderData: FlBorderData(show: false),
        lineTouchData: LineTouchData(enabled: false),
        lineBarsData: [
          LineChartBarData(
            spots: spots,
            isCurved: true,
            preventCurveOverShooting: true,
            color: color,
            barWidth: 2.5,
            isStrokeCapRound: true,
            dotData: FlDotData(show: false),
            belowBarData: BarAreaData(
              show: true,
              color: color.withOpacity(0.3),
            ),
          ),
        ],
      ),
    );
  }
}
