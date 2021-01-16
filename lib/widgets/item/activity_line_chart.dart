import 'package:cabin_booking/utils/date.dart';
import 'package:cabin_booking/widgets/layout/detail_line_chart.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ActivityLineChart extends StatelessWidget {
  final Map<DateTime, Duration> occupiedDurationPerWeek;

  const ActivityLineChart({this.occupiedDurationPerWeek = const {}});

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: AppLocalizations.of(context).pastYearOfActivity,
      child: Container(
        width: 250.0,
        padding: const EdgeInsets.symmetric(vertical: 24.0),
        child: DetailLineChart(
          minX: dateToInt(
            firstWeekDate(DateTime.now().subtract(const Duration(days: 365))),
          ).toDouble(),
          maxX: dateToInt(firstWeekDate(DateTime.now())).toDouble(),
          spots: [
            for (final entry in occupiedDurationPerWeek.entries)
              FlSpot(
                dateToInt(entry.key).toDouble(),
                entry.value.inMinutes.toDouble(),
              ),
          ],
        ),
      ),
    );
  }
}
