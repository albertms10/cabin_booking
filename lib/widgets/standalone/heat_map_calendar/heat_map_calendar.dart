import 'package:flutter/material.dart';

import 'heat_map_legend.dart';
import 'week_columns.dart';
import 'week_days_labels.dart';

/// Source: https://pub.dev/packages/heatmap_calendar.
class HeatMapCalendar extends StatelessWidget {
  static const int columnCount = DateTime.daysPerWeek + 1;
  static const int edgeSize = 4;

  /// The inputs that will fill the calendar with data.
  final Map<DateTime, int> input;

  /// The thresholds which will map the given [input] to a color.
  ///
  /// Make sure to map starting on number 1, so the user might notice
  /// the difference between a day that had no input and one that had.
  ///
  /// Example:
  /// ```dart
  /// {
  ///   1: Colors.green[100],
  ///   20: Colors.green[200],
  ///   40: Colors.green[300],
  /// }
  /// ```
  final Map<int, Color> colorThresholds;

  /// The day of the week (Monday to Sunday).
  final int firstWeekDay;

  /// The size of each item of the calendar.
  final double squareSize;

  /// Space between elements.
  final double space;

  final void Function(DateTime, int)? onDayTap;
  final String Function(int)? dayValueWrapper;

  final bool showLegend;
  final int legendSamples;
  final String? legendLessLabel;
  final String? legendMoreLabel;

  final DateTime? firstDate;
  final DateTime? lastDate;
  final bool highlightToday;
  final bool Function(DateTime)? highlightOn;

  const HeatMapCalendar({
    Key? key,
    required this.input,
    required this.colorThresholds,
    this.firstWeekDay = DateTime.sunday,
    this.squareSize = 16.0,
    this.space = 4.0,
    this.onDayTap,
    this.dayValueWrapper,
    this.showLegend = false,
    this.legendSamples = 5,
    this.legendLessLabel,
    this.legendMoreLabel,
    this.firstDate,
    this.lastDate,
    this.highlightToday = false,
    this.highlightOn,
  })  : assert(firstWeekDay >= 1 && firstWeekDay <= DateTime.daysPerWeek),
        super(key: key);

  /// Calculates the right amount of columns to create based on [maxWidth]
  ///
  /// returns the number of columns that the widget should have
  int getColumnsToCreate(double maxWidth) {
    assert(maxWidth > 2.0 * (squareSize + HeatMapCalendar.edgeSize));

    return maxWidth ~/ (squareSize + HeatMapCalendar.edgeSize);
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                WeekDaysLabels(
                  squareSize: squareSize,
                  firstWeekDay: firstWeekDay,
                  space: space,
                ),
                WeekColumns(
                  squareSize: squareSize,
                  space: space,
                  input: input,
                  colorThresholds: colorThresholds,
                  firstWeekDay: firstWeekDay,
                  columnsToCreate: getColumnsToCreate(constraints.maxWidth) - 1,
                  firstDate: firstDate,
                  lastDate: lastDate ?? DateTime.now(),
                  onDayTap: onDayTap,
                  dayValueWrapper: dayValueWrapper,
                  highlightToday: highlightToday,
                  highlightOn: highlightOn,
                ),
              ],
            ),
            if (showLegend)
              Padding(
                padding: const EdgeInsets.only(top: 16.0, right: 24.0),
                child: HeatMapLegend(
                  squareSize: squareSize,
                  space: space,
                  color: Theme.of(context).colorScheme.secondary,
                  samples: legendSamples,
                  lessLabel: legendLessLabel,
                  moreLabel: legendMoreLabel,
                ),
              ),
          ],
        );
      },
    );
  }
}
