import 'package:cabin_booking/model/cabin_manager.dart';
import 'package:cabin_booking/model/day_handler.dart';
import 'package:cabin_booking/utils/color_extension.dart';
import 'package:cabin_booking/utils/date_time_extension.dart';
import 'package:cabin_booking/utils/map_extension.dart';
import 'package:cabin_booking/widgets/layout/detailed_figure.dart';
import 'package:cabin_booking/widgets/layout/duration_figure_unit.dart';
import 'package:cabin_booking/widgets/layout/heading.dart';
import 'package:cabin_booking/widgets/layout/popular_times_bar_chart.dart';
import 'package:cabin_booking/widgets/layout/radio_button_list.dart';
import 'package:cabin_booking/widgets/layout/statistics.dart';
import 'package:cabin_booking/widgets/layout/statistics_item.dart';
import 'package:cabin_booking/widgets/layout/statistics_simple_item.dart';
import 'package:cabin_booking/widgets/pages/home_page.dart';
import 'package:cabin_booking/widgets/standalone/heat_map_calendar/heat_map_calendar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class SummaryPage extends StatefulWidget {
  final void Function(AppPages)? setNavigationPage;

  const SummaryPage({Key? key, this.setNavigationPage}) : super(key: key);

  @override
  State<SummaryPage> createState() => _SummaryPageState();
}

class _SummaryPageState extends State<SummaryPage>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);

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
                  onTap: widget.setNavigationPage == null
                      ? null
                      : () {
                          widget.setNavigationPage!.call(AppPages.bookings);
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
                        tooltipMessage: '${appLocalizations.bookings}'
                            ' + ${appLocalizations.recurringBookings}',
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
                  onTap: widget.setNavigationPage == null
                      ? null
                      : () {
                          widget.setNavigationPage!.call(AppPages.cabins);
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
                  onTap: widget.setNavigationPage == null
                      ? null
                      : () {
                          widget.setNavigationPage!.call(AppPages.schoolYears);
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
                    onTap: widget.setNavigationPage == null
                        ? null
                        : () {
                            dayHandler.dateTime =
                                cabinManager.mostBookedDayEntry!.key;
                            widget.setNavigationPage!.call(AppPages.bookings);
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
                      timeRangesOccupancy: cabinManager
                          .accumulatedTimeRangesOccupancy()
                          .fillEmptyKeyValues(
                        keys: [
                          for (var i = 9; i < 22; i++)
                            TimeOfDay(hour: i, minute: 0),
                        ],
                        ifAbsent: () => Duration.zero,
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
                    dayValueWrapper: appLocalizations.nBookings,
                    showLegend: true,
                    colorThresholds: Theme.of(context)
                        .colorScheme
                        .secondary
                        .opacityThresholds(
                          highestValue:
                              cabinManager.mostBookedDayEntry?.value ?? 1,
                          samples: 8,
                        ),
                    firstWeekDay: DateTime.monday,
                    firstDate:
                        dayHandler.schoolYearManager.schoolYear?.startDate,
                    lastDate: dayHandler.schoolYearManager.schoolYear?.endDate,
                    highlightToday: true,
                    highlightOn: (date) =>
                        date.isSameDateAs(dayHandler.dateTime),
                    onDayTap: widget.setNavigationPage == null
                        ? null
                        : (dateTime, value) {
                            dayHandler.dateTime = dateTime;
                            widget.setNavigationPage!.call(AppPages.bookings);
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
                      dayHandler.schoolYearManager.schoolYears
                          .elementAt(index)
                          .toString(),
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
