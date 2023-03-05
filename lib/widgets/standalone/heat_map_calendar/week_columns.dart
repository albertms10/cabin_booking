// ignore_for_file: avoid-returning-widgets

import 'package:cabin_booking/utils/map_int_color_extension.dart';
import 'package:cabin_booking/utils/num_extension.dart';
import 'package:flutter/material.dart';

import 'heat_map_calendar.dart';
import 'heat_map_day.dart';
import 'month_label.dart';
import 'utils/time.dart';

class WeekColumns extends StatelessWidget {
  final Map<DateTime, int> input;
  final Map<int, Color> colorThresholds;
  final int firstWeekDay;
  final int columnsToCreate;
  final double squareSize;
  final double space;
  final DateTime? firstDate;
  final DateTime lastDate;
  final void Function(DateTime, int)? onDayTap;
  final String Function(int)? dayValueWrapper;
  final bool highlightToday;
  final bool Function(DateTime)? highlightOn;

  const WeekColumns({
    super.key,
    required this.squareSize,
    required this.input,
    required this.colorThresholds,
    this.firstWeekDay = DateTime.sunday,
    required this.columnsToCreate,
    this.firstDate,
    required this.lastDate,
    this.onDayTap,
    this.space = 4,
    this.dayValueWrapper,
    this.highlightToday = false,
    this.highlightOn,
  });

  EdgeInsetsGeometry get padding => EdgeInsets.all(space * 0.5);

  /// The main logic for generating a list of columns representing a week.
  ///
  /// Each column is a week with a [MonthLabel] and 7 [HeatMapDay] Widgets.
  List<Widget> buildWeekItems(BuildContext context) {
    final dateList = calendarDatesFromColumns(columnsToCreate);

    if (dateList.isEmpty) return <Widget>[];

    final totalWeeks = (dateList.length / DateTime.daysPerWeek).ceil();
    final amount = dateList.length + totalWeeks + dateList.first.weekday;

    // The list of columns that will be returned.
    final columns = <Widget>[];

    // The list of items that will be used to form a week.
    var columnItems = <Widget>[];
    final months = <int>[];

    var runWeekDayCount = (dateList.first.weekday - firstWeekDay).weekdayMod();
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
          monthLabel = monthsLabels[firstMonth - 1];
          months.add(firstMonth);

          columnItems.add(MonthLabel(text: monthLabel, size: squareSize));
        } else {
          columnItems.add(SizedBox(height: squareSize));
        }
      } else {
        if (isFirstColumn) {
          runWeekDayCount--;

          if (runWeekDayCount >= 0) {
            columnItems.add(
              Padding(
                padding: padding,
                child: SizedBox.square(dimension: squareSize),
              ),
            );

            continue;
          } else {
            isFirstColumn = false;
          }
        }

        dateList.removeAt(0);

        final threshold = input[currentDate] ?? 0;
        columnItems.add(
          HeatMapDay(
            value: threshold,
            size: squareSize,
            padding: padding,
            color: colorThresholds.colorFromThreshold(threshold),
            date: currentDate,
            onTap: onDayTap,
            valueWrapper: dayValueWrapper,
            highlightToday: highlightToday,
            highlightOn: highlightOn,
          ),
        );

        if (columnItems.length == HeatMapCalendar.columnCount) {
          columns.add(Column(children: columnItems));

          columnItems = <Widget>[];
        }
      }
    }

    if (columnItems.isNotEmpty) {
      columns.add(Column(children: columnItems));
    }

    return columns;
  }

  /// Creates a list of all weeks based on given [columnAmount].
  List<DateTime> calendarDatesFromColumns(int columnAmount) {
    final firstDay =
        firstDayOfCalendar(firstDayOfTheWeek(lastDate), columnAmount);

    return datesBetween(
      firstDate?.isAfter(firstDay) ?? false ? firstDate! : firstDay,
      lastDate,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: buildWeekItems(context),
      ),
    );
  }
}
