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
    this.minY = 0,
    this.maxY,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = theme.colorScheme.primary;

    return LineChart(
      LineChartData(
        lineBarsData: [
          LineChartBarData(
            spots: spots,
            color: color,
            barWidth: 2.5,
            isCurved: true,
            preventCurveOverShooting: true,
            isStrokeCapRound: true,
            belowBarData:
                BarAreaData(show: true, color: color.withOpacity(0.3)),
            dotData: FlDotData(show: false),
          ),
        ],
        titlesData: FlTitlesData(show: false),
        lineTouchData: LineTouchData(enabled: false),
        gridData: FlGridData(show: false),
        borderData: FlBorderData(show: false),
        minX: minX,
        maxX: maxX,
        minY: minY,
        maxY: maxY,
      ),
    );
  }
}
