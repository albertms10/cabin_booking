import 'package:flutter/material.dart';

import 'heatmap_legend.dart';
import 'time_utils.dart';
import 'week_columns.dart';
import 'week_labels.dart';

/// Source: https://pub.dev/packages/heatmap_calendar
class HeatMapCalendar extends StatelessWidget {
  static const int COLUMN_COUNT = DateTime.daysPerWeek + 1;
  static const int EDGE_SIZE = 4;

  /// The labels identifying the initials of the days of the week
  /// Defaults to [TimeUtils.defaultWeekLabels]
  final List<String> weekDaysLabels;

  /// The labels identifying the months of a year
  /// Defaults to [TimeUtils.defaultMonthsLabels]
  final List<String> monthsLabels;

  /// The inputs that will fill the calendar with data
  final Map<DateTime, int> input;

  /// The thresholds which will map the given [input] to a color
  ///
  /// Make sure to map starting on number 1, so the user might notice the difference between
  /// a day that had no input and one that had
  /// Example: {1: Colors.green[100], 20: Colors.green[200], 40: Colors.green[300]}
  final Map<int, Color> colorThresholds;

  /// The size of each item of the calendar
  final double squareSize;

  /// Space between elements
  final double space;

  final void Function(DateTime, int) onDayTap;

  final String Function(int) dayValueWrapper;

  final bool showLegend;

  const HeatMapCalendar({
    Key key,
    @required this.input,
    @required this.colorThresholds,
    this.weekDaysLabels = TimeUtils.defaultWeekLabels,
    this.monthsLabels = TimeUtils.defaultMonthsLabels,
    this.squareSize = 16.0,
    this.space = 4.0,
    this.onDayTap,
    this.dayValueWrapper,
    this.showLegend = false,
  }) : super(key: key);

  /// Calculates the right amount of columns to create based on [maxWidth]
  ///
  /// returns the number of columns that the widget should have
  int getColumnsToCreate(double maxWidth) {
    assert(maxWidth > (2 * (HeatMapCalendar.EDGE_SIZE + squareSize)));

    return maxWidth ~/ (squareSize + HeatMapCalendar.EDGE_SIZE);
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Row(
              children: [
                WeekLabels(
                  weekDaysLabels: weekDaysLabels,
                  squareSize: squareSize,
                  space: space,
                ),
                WeekColumns(
                  squareSize: squareSize,
                  space: space,
                  input: input,
                  colorThresholds: colorThresholds,
                  monthLabels: monthsLabels,
                  columnsToCreate: getColumnsToCreate(constraints.maxWidth) - 1,
                  date: DateTime.now(),
                  onDayTap: onDayTap,
                  dayValueWrapper: dayValueWrapper,
                ),
              ],
            ),
            if (showLegend)
              Padding(
                padding: const EdgeInsets.only(top: 16.0, right: 24.0),
                child: HeatMapLegend(
                  squareSize: squareSize,
                  space: space,
                  color: Theme.of(context).accentColor,
                ),
              ),
          ],
        );
      },
    );
  }
}
