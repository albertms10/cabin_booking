import 'package:flutter/material.dart';

import 'heatmap_calendar.dart';
import 'heatmap_day.dart';
import 'month_label.dart';
import 'time_utils.dart';

class WeekColumns extends StatelessWidget {
  final Map<DateTime, int> input;
  final Map<int, Color> colorThresholds;
  final List<String> monthLabels;
  final int columnsToCreate;
  final double squareSize;
  final double space;
  final DateTime date;
  final void Function(DateTime, int) onDayTap;
  final String Function(int) dayValueWrapper;

  const WeekColumns({
    Key key,
    @required this.squareSize,
    @required this.input,
    @required this.colorThresholds,
    @required this.monthLabels,
    @required this.columnsToCreate,
    @required this.date,
    this.onDayTap,
    this.space = 4.0,
    this.dayValueWrapper,
  }) : super(key: key);

  /// The main logic for generating a list of columns representing a week
  /// Each column is a week having a [MonthLabel] and 7 [HeatMapDay] widgets
  List<Widget> buildWeekItems() {
    final dateList = getCalendarDates(columnsToCreate);

    final totalWeeks = (dateList.length / DateTime.daysPerWeek).ceil();
    final amount = dateList.length + totalWeeks;

    // The list of columns that will be returned
    final columns = <Widget>[];

    // The list of items that will be used to form a week
    var columnItems = <Widget>[];
    final months = <int>[];

    for (var i = 0; i < amount; i++) {
      if (dateList.isEmpty) break;

      final currentDate = dateList.first;

      // If true, it means that it should be a label,
      // if false, it should be a HeatMapDay
      if (i % HeatMapCalendar.COLUMN_COUNT == 0) {
        final firstMonth = dateList.first.month;
        String monthLabel;

        if ((months.isEmpty || months.last != firstMonth) &&
            currentDate.day <= 14) {
          monthLabel = monthLabels[firstMonth - 1];
          months.add(firstMonth);

          columnItems.add(
            MonthLabel(
              size: squareSize,
              text: monthLabel,
            ),
          );
        } else {
          columnItems.add(
            SizedBox(height: squareSize),
          );
        }
      } else {
        dateList.removeAt(0);

        columnItems.add(
          HeatMapDay(
            value: input[currentDate] ?? 0,
            thresholds: colorThresholds,
            size: squareSize,
            space: space,
            date: currentDate,
            onTap: onDayTap,
            valueWrapper: dayValueWrapper,
          ),
        );

        if (columnItems.length == HeatMapCalendar.COLUMN_COUNT) {
          columns.add(
            Column(children: columnItems),
          );

          columnItems = <Widget>[];
        }
      }
    }

    if (columnItems.isNotEmpty) {
      columns.add(
        Column(children: columnItems),
      );
    }

    return columns;
  }

  /// Creates a list of all weeks based on given [columnsAmount]
  List<DateTime> getCalendarDates(int columnsAmount) {
    final firstDayOfTheWeek = TimeUtils.firstDayOfTheWeek(date);
    final firstDayOfCalendar =
        TimeUtils.firstDayOfCalendar(firstDayOfTheWeek, columnsAmount);

    return TimeUtils.datesBetween(firstDayOfCalendar, date);
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: buildWeekItems(),
      ),
    );
  }
}
