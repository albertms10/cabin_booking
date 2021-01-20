import 'package:cabin_booking/utils/datetime.dart';
import 'package:flutter/material.dart';

import 'heat_map_calendar.dart';
import 'heat_map_day.dart';
import 'month_label.dart';
import 'time_utils.dart';

class WeekColumns extends StatelessWidget {
  final Map<DateTime, int> input;
  final Map<int, Color> colorThresholds;
  final int firstWeekDay;
  final int columnsToCreate;
  final double squareSize;
  final double space;
  final DateTime firstDate;
  final DateTime lastDate;
  final void Function(DateTime, int) onDayTap;
  final String Function(int) dayValueWrapper;
  final bool highlightToday;
  final bool Function(DateTime) highlightOn;

  const WeekColumns({
    Key key,
    @required this.squareSize,
    @required this.input,
    @required this.colorThresholds,
    this.firstWeekDay = DateTime.sunday,
    @required this.columnsToCreate,
    this.firstDate,
    @required this.lastDate,
    this.onDayTap,
    this.space = 4.0,
    this.dayValueWrapper,
    this.highlightToday = false,
    this.highlightOn,
  }) : super(key: key);

  /// The main logic for generating a list of columns representing a week.
  ///
  /// Each column is a week with a [MonthLabel] and 7 [HeatMapDay] widgets
  List<Widget> buildWeekItems() {
    final dateList = getCalendarDates(columnsToCreate);

    if (dateList.isEmpty) return [];

    final totalWeeks = (dateList.length / DateTime.daysPerWeek).ceil();
    final amount = dateList.length + totalWeeks + dateList.first.weekday;

    // The list of columns that will be returned
    final columns = <Widget>[];

    // The list of items that will be used to form a week
    var columnItems = <Widget>[];
    final months = <int>[];

    var runWeekDayCount = weekDayMod(dateList.first.weekday - firstWeekDay);
    var isFirstColumn = true;

    for (var i = 0; i < amount; i++) {
      if (dateList.isEmpty) break;

      final currentDate = dateList.first;

      /// If `true`, it should be a [MonthLabel].
      /// If `false`, it should be a [HeatMapDay].
      if (i % HeatMapCalendar.columnCount == 0) {
        final firstMonth = dateList.first.month;
        String monthLabel;

        if ((months.isEmpty || months.last != firstMonth) &&
            currentDate.day <= 14) {
          monthLabel = TimeUtils.monthsLabels[firstMonth - 1];
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
        if (isFirstColumn) {
          runWeekDayCount--;

          if (runWeekDayCount >= 0) {
            columnItems.add(
              Padding(
                padding: EdgeInsets.all(space / 2.0),
                child: SizedBox(height: squareSize, width: squareSize),
              ),
            );

            continue;
          } else {
            isFirstColumn = false;
          }
        }

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
            highlightToday: highlightToday,
            highlightOn: highlightOn,
          ),
        );

        if (columnItems.length == HeatMapCalendar.columnCount) {
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
    final firstDayOfTheWeek = TimeUtils.firstDayOfTheWeek(lastDate);
    final firstDayOfCalendar =
        TimeUtils.firstDayOfCalendar(firstDayOfTheWeek, columnsAmount);

    return TimeUtils.datesBetween(
      firstDate != null && firstDate.isAfter(firstDayOfCalendar)
          ? firstDate
          : firstDayOfCalendar,
      lastDate,
    );
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
