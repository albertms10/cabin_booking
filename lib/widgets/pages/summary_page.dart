import 'package:cabin_booking/model.dart';
import 'package:cabin_booking/utils/map_extension.dart';
import 'package:cabin_booking/widgets/booking/bookings_heat_map_calendar.dart';
import 'package:cabin_booking/widgets/layout/detailed_figure.dart';
import 'package:cabin_booking/widgets/layout/duration_figure_unit.dart';
import 'package:cabin_booking/widgets/layout/heading.dart';
import 'package:cabin_booking/widgets/layout/popular_times_bar_chart.dart';
import 'package:cabin_booking/widgets/layout/statistic_item.dart';
import 'package:cabin_booking/widgets/layout/statistic_simple_item.dart';
import 'package:cabin_booking/widgets/layout/statistics.dart';
import 'package:cabin_booking/widgets/pages/home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class SummaryPage extends StatefulWidget {
  const SummaryPage({super.key});

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
    final homePageState = HomePage.of(context);

    return ListView(
      padding: const EdgeInsets.all(32),
      children: [
        Heading(appLocalizations.summary),
        Wrap(
          spacing: 24,
          runSpacing: 24,
          children: [
            _BookingsCountStatistics(
              onTap: () {
                homePageState?.setNavigationPage(AppPage.bookings);
              },
            ),
            _CabinsCountStatistics(
              onTap: () {
                homePageState?.setNavigationPage(AppPage.cabins);
              },
            ),
            _SchoolYearsStatistics(
              onTap: () {
                homePageState?.setNavigationPage(AppPage.schoolYears);
              },
            ),
            _MostBookedDayStatistics(
              onTap: () {
                homePageState?.setNavigationPage(AppPage.bookings);
              },
            ),
            const _PopularTimesStatistics(),
          ],
        ),
        const SizedBox(height: 32),
        Heading(appLocalizations.bookings),
        const SizedBox(height: 16),
        BookingsHeatMapCalendar(
          onDayTap: () {
            homePageState?.setNavigationPage(AppPage.bookings);
          },
        ),
      ],
    );
  }
}

class _BookingsCountStatistics extends StatelessWidget {
  final VoidCallback? onTap;

  const _BookingsCountStatistics({super.key, this.onTap});

  @override
  Widget build(BuildContext context) {
    final appLocalizations = AppLocalizations.of(context)!;

    final cabinCollection = Provider.of<CabinCollection>(context);

    return Statistics(
      title: appLocalizations.bookings,
      icon: Icons.event,
      items: [
        StatisticItem(
          label: appLocalizations.total,
          item: DetailedFigure(
            figure: cabinCollection.allBookingsCount,
            details: [
              cabinCollection.bookingsCount,
              cabinCollection.recurringBookingsCount,
            ],
            tooltipMessage: '${appLocalizations.bookings}'
                ' + ${appLocalizations.recurringBookings}',
          ),
        ),
        StatisticItem(
          label: appLocalizations.accumulatedTime,
          item: DurationFigureUnit(cabinCollection.totalOccupiedDuration()),
        ),
      ],
      onTap: onTap,
    );
  }
}

class _CabinsCountStatistics extends StatelessWidget {
  final VoidCallback? onTap;

  const _CabinsCountStatistics({super.key, this.onTap});

  @override
  Widget build(BuildContext context) {
    final appLocalizations = AppLocalizations.of(context)!;

    final cabinCollection = Provider.of<CabinCollection>(context);

    return Statistics(
      title: appLocalizations.cabins,
      icon: Icons.sensor_door,
      items: [
        StatisticSimpleItem(
          label: appLocalizations.total,
          value: cabinCollection.cabins.length,
        ),
      ],
      onTap: onTap,
    );
  }
}

class _SchoolYearsStatistics extends StatelessWidget {
  final VoidCallback? onTap;

  const _SchoolYearsStatistics({super.key, this.onTap});

  @override
  Widget build(BuildContext context) {
    final appLocalizations = AppLocalizations.of(context)!;

    final dayHandler = Provider.of<DayHandler>(context);

    return Statistics(
      title: appLocalizations.schoolYears,
      icon: Icons.school,
      items: [
        StatisticSimpleItem(
          label: appLocalizations.total,
          value: dayHandler.schoolYearCollection.schoolYears.length,
        ),
        StatisticSimpleItem(
          label: appLocalizations.workingDays,
          value: dayHandler.schoolYearCollection.totalWorkingDuration.inDays,
        ),
      ],
      onTap: onTap,
    );
  }
}

class _MostBookedDayStatistics extends StatelessWidget {
  final VoidCallback? onTap;

  const _MostBookedDayStatistics({super.key, this.onTap});

  @override
  Widget build(BuildContext context) {
    final appLocalizations = AppLocalizations.of(context)!;

    final cabinCollection = Provider.of<CabinCollection>(context);
    if (cabinCollection.mostBookedDayEntry == null) return const SizedBox();

    final dayHandler = Provider.of<DayHandler>(context);

    return Statistics(
      title: appLocalizations.mostBookedDay,
      icon: Icons.calendar_today,
      items: [
        StatisticSimpleItem(
          value: DateFormat.d()
              .add_MMM()
              .add_y()
              .format(cabinCollection.mostBookedDayEntry!.key),
        ),
      ],
      onTap: onTap == null
          ? null
          : () {
              dayHandler.dateTime = cabinCollection.mostBookedDayEntry!.key;
              onTap!.call();
            },
    );
  }
}

class _PopularTimesStatistics extends StatelessWidget {
  const _PopularTimesStatistics({super.key});

  @override
  Widget build(BuildContext context) {
    final appLocalizations = AppLocalizations.of(context)!;

    final cabinCollection = Provider.of<CabinCollection>(context);

    return Statistics(
      title: appLocalizations.popularTimes,
      icon: Icons.watch_later,
      items: [
        PopularTimesBarChart(
          timeRangesOccupancy: cabinCollection.accumulatedTimeRangesOccupancy()
            ..fillEmptyKeyValues(
              keys: [
                for (var i = 9; i < 22; i++) TimeOfDay(hour: i, minute: 0),
              ],
              ifAbsent: () => Duration.zero,
            ),
        ),
      ],
    );
  }
}
