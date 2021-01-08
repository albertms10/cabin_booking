import 'package:cabin_booking/model/cabin_manager.dart';
import 'package:cabin_booking/model/day_handler.dart';
import 'package:cabin_booking/utils/colors.dart';
import 'package:cabin_booking/utils/date.dart';
import 'package:cabin_booking/widgets/layout/detailed_figure.dart';
import 'package:cabin_booking/widgets/layout/duration_figure_unit.dart';
import 'package:cabin_booking/widgets/layout/heading.dart';
import 'package:cabin_booking/widgets/layout/statistics.dart';
import 'package:cabin_booking/widgets/pages/home_page.dart';
import 'package:cabin_booking/widgets/standalone/heatmap_calendar/heatmap_calendar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class SummaryPage extends StatelessWidget {
  final void Function(AppPages) setRailPage;

  const SummaryPage({this.setRailPage});

  @override
  Widget build(BuildContext context) {
    final appLocalizations = AppLocalizations.of(context);

    return Consumer2<DayHandler, CabinManager>(
      builder: (context, dayHandler, cabinManager, child) {
        return ListView(
          padding: const EdgeInsets.all(32.0),
          children: [
            Heading(AppLocalizations.of(context).summary),
            Wrap(
              spacing: 24.0,
              runSpacing: 24.0,
              children: [
                Statistics(
                  title: appLocalizations.bookings,
                  icon: Icons.event,
                  onTap: () {
                    setRailPage(AppPages.Bookings);
                  },
                  items: [
                    StatisticItem(
                      label: appLocalizations.total,
                      item: DetailedFigure(
                        figure: cabinManager.allBookingsCount,
                        details: [
                          cabinManager.bookingsCount,
                          cabinManager.recurringBookingsCount,
                        ],
                        tooltipMessage:
                            '${appLocalizations.bookings} + ${appLocalizations.recurringBookings}',
                      ),
                    ),
                    StatisticItem(
                      label: appLocalizations.accumulatedTime,
                      item: DurationFigureUnit(
                        cabinManager.totalOccupiedDuration(),
                      ),
                    ),
                  ],
                ),
                Statistics(
                  title: appLocalizations.cabins,
                  icon: Icons.sensor_door,
                  onTap: () {
                    setRailPage(AppPages.Cabins);
                  },
                  items: [
                    StatisticSimpleItem(
                      label: appLocalizations.total,
                      value: cabinManager.cabins.length,
                    ),
                  ],
                ),
                Statistics(
                  title: appLocalizations.schoolYears,
                  icon: Icons.school,
                  onTap: () {
                    setRailPage(AppPages.SchoolYears);
                  },
                  items: [
                    StatisticSimpleItem(
                      label: appLocalizations.total,
                      value: dayHandler.schoolYearManager.schoolYears.length,
                    ),
                    StatisticSimpleItem(
                      label: appLocalizations.workingDays,
                      value: dayHandler
                          .schoolYearManager.totalWorkingDuration.inDays,
                    ),
                  ],
                ),
                if (cabinManager.mostBookedDayEntry != null)
                  Statistics(
                    title: appLocalizations.mostBookedDay,
                    icon: Icons.calendar_today,
                    onTap: () {
                      dayHandler.dateTime = cabinManager.mostBookedDayEntry.key;
                      setRailPage(AppPages.Bookings);
                    },
                    items: [
                      StatisticSimpleItem(
                        value: DateFormat.d().add_MMM().add_y().format(
                              cabinManager.mostBookedDayEntry.key,
                            ),
                      ),
                    ],
                  ),
              ],
            ),
            const SizedBox(height: 32.0),
            Heading(AppLocalizations.of(context).bookings),
            const SizedBox(height: 16.0),
            Row(
              children: [
                Expanded(
                  child: HeatMapCalendar(
                    input: cabinManager.allCabinsBookingsCountPerDay,
                    dayValueWrapper: (value) =>
                        '${AppLocalizations.of(context).nBookings(value)}',
                    showLegend: true,
                    colorThresholds: mapColorsToHighestValue(
                      highestValue: cabinManager.mostBookedDayEntry?.value ?? 1,
                      color: Theme.of(context).accentColor,
                    ),
                    firstWeekDay: DateTime.monday,
                    firstDate:
                        dayHandler.schoolYearManager.schoolYear?.startDate,
                    lastDate: dayHandler.schoolYearManager.schoolYear?.endDate,
                    highlightToday: true,
                    highlightOn: (date) => isSameDay(date, dayHandler.dateTime),
                    onDayTap: (dateTime, value) {
                      dayHandler.dateTime = dateTime;

                      setRailPage(AppPages.Bookings);
                    },
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}
