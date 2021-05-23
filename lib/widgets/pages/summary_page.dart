import 'package:cabin_booking/model/cabin_manager.dart';
import 'package:cabin_booking/model/day_handler.dart';
import 'package:cabin_booking/utils/colors.dart';
import 'package:cabin_booking/utils/datetime.dart';
import 'package:cabin_booking/widgets/layout/detailed_figure.dart';
import 'package:cabin_booking/widgets/layout/duration_figure_unit.dart';
import 'package:cabin_booking/widgets/layout/heading.dart';
import 'package:cabin_booking/widgets/layout/popular_times_bar_chart.dart';
import 'package:cabin_booking/widgets/layout/radio_button_list.dart';
import 'package:cabin_booking/widgets/layout/statistics.dart';
import 'package:cabin_booking/widgets/pages/home_page.dart';
import 'package:cabin_booking/widgets/standalone/heat_map_calendar/heat_map_calendar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class SummaryPage extends StatelessWidget {
  final void Function(AppPages)? setNavigationPage;

  const SummaryPage({this.setNavigationPage});

  @override
  Widget build(BuildContext context) {
    final appLocalizations = AppLocalizations.of(context)!;

    return Consumer2<DayHandler, CabinManager>(
      builder: (context, dayHandler, cabinManager, child) {
        return ListView(
          padding: const EdgeInsets.all(32.0),
          children: [
            Heading(appLocalizations.summary),
            Wrap(
              spacing: 24.0,
              runSpacing: 24.0,
              children: [
                Statistics(
                  title: appLocalizations.bookings,
                  icon: Icons.event,
                  onTap: setNavigationPage == null
                      ? null
                      : () {
                          setNavigationPage!.call(AppPages.Bookings);
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
                  onTap: setNavigationPage == null
                      ? null
                      : () {
                          setNavigationPage!.call(AppPages.Cabins);
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
                  onTap: setNavigationPage == null
                      ? null
                      : () {
                          setNavigationPage!.call(AppPages.SchoolYears);
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
                    onTap: setNavigationPage == null
                        ? null
                        : () {
                            dayHandler.dateTime =
                                cabinManager.mostBookedDayEntry!.key;
                            setNavigationPage!.call(AppPages.Bookings);
                          },
                    items: [
                      StatisticSimpleItem(
                        value: DateFormat.d().add_MMM().add_y().format(
                              cabinManager.mostBookedDayEntry!.key,
                            ),
                      ),
                    ],
                  ),
                Statistics(
                  title: appLocalizations.popularTimes,
                  icon: Icons.watch_later,
                  items: [
                    PopularTimesBarChart(
                      timeRangesOccupancy: fillEmptyKeyValues(
                        cabinManager.accumulatedTimeRangesOccupancy(),
                        keys: [
                          for (var i = 9; i < 22; i++)
                            TimeOfDay(hour: i, minute: 0),
                        ],
                        ifAbsent: () => const Duration(),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 32.0),
            Heading(appLocalizations.bookings),
            const SizedBox(height: 16.0),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: HeatMapCalendar(
                    input: cabinManager.allCabinsBookingsCountPerDay,
                    dayValueWrapper: (value) =>
                        '${appLocalizations.nBookings(value)}',
                    showLegend: true,
                    colorThresholds: mapColorsToHighestValue(
                      highestValue: cabinManager.mostBookedDayEntry?.value ?? 1,
                      color: Theme.of(context).colorScheme.secondary,
                      colorSamples: 8,
                    ),
                    firstWeekDay: DateTime.monday,
                    firstDate:
                        dayHandler.schoolYearManager.schoolYear?.startDate,
                    lastDate: dayHandler.schoolYearManager.schoolYear?.endDate,
                    highlightToday: true,
                    highlightOn: (date) => isSameDay(date, dayHandler.dateTime),
                    onDayTap: setNavigationPage == null
                        ? null
                        : (dateTime, value) {
                            dayHandler.dateTime = dateTime;
                            setNavigationPage!.call(AppPages.Bookings);
                          },
                    legendLessLabel: appLocalizations.less,
                    legendMoreLabel: appLocalizations.more,
                  ),
                ),
                const SizedBox(width: 16.0),
                RadioButtonList(
                  itemCount: dayHandler.schoolYearManager.schoolYears.length,
                  itemBuilder: (context, index) {
                    return Text(
                      '${dayHandler.schoolYearManager.schoolYears.elementAt(index)}',
                    );
                  },
                  initialIndex: dayHandler.schoolYearManager.schoolYearIndex,
                  onChanged: (index) => dayHandler.schoolYearIndex = index,
                  reverse: true,
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}
