import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class DetailLineChart extends StatelessWidget {
  final List<FlSpot> spots;
  final double? minX;
  final double? maxX;
  final double minY;
  final double? maxY;

  const DetailLineChart({
    Key? key,
    required this.spots,
    this.minX,
    this.maxX,
    this.minY = 0.0,
    this.maxY,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final colors = [
      theme.colorScheme.primary,
      theme.colorScheme.secondaryVariant,
    ];

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
            colors: colors,
            barWidth: 2.5,
            isStrokeCapRound: true,
            dotData: FlDotData(show: false),
            belowBarData: BarAreaData(
              show: true,
              colors: colors.map((color) => color.withOpacity(0.3)).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
