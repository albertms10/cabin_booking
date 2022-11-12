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
  final void Function(AppPages)? setNavigationPage;

  const SummaryPage({super.key, this.setNavigationPage});

  @override
  _SummaryPageState createState() => _SummaryPageState();
}

class _SummaryPageState extends State<SummaryPage>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);

    final appLocalizations = AppLocalizations.of(context)!;

    return ListView(
      padding: const EdgeInsets.all(32.0),
      children: [
        Heading(appLocalizations.summary),
        Wrap(
          spacing: 24.0,
          runSpacing: 24.0,
          children: [
            _BookingsCountStatistics(
              onTap: () {
                widget.setNavigationPage?.call(AppPages.bookings);
              },
            ),
            _CabinsCountStatistics(
              onTap: () {
                widget.setNavigationPage?.call(AppPages.cabins);
              },
            ),
            _SchoolYearsStatistics(
              onTap: () {
                widget.setNavigationPage?.call(AppPages.schoolYears);
              },
            ),
            _MostBookedDayStatistics(
              onTap: () {
                widget.setNavigationPage?.call(AppPages.bookings);
              },
            ),
            const _PopularTimesStatistics(),
          ],
        ),
        const SizedBox(height: 32.0),
        Heading(appLocalizations.bookings),
        const SizedBox(height: 16.0),
        BookingsHeatMapCalendar(
          onDayTap: () {
            widget.setNavigationPage?.call(AppPages.bookings);
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

    final cabinManager = Provider.of<CabinManager>(context);

    return Statistics(
      title: appLocalizations.bookings,
      icon: Icons.event,
      onTap: onTap,
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
    );
  }
}

class _CabinsCountStatistics extends StatelessWidget {
  final VoidCallback? onTap;

  const _CabinsCountStatistics({super.key, this.onTap});

  @override
  Widget build(BuildContext context) {
    final appLocalizations = AppLocalizations.of(context)!;

    final cabinManager = Provider.of<CabinManager>(context);

    return Statistics(
      title: appLocalizations.cabins,
      icon: Icons.sensor_door,
      onTap: onTap,
      items: [
        StatisticSimpleItem(
          label: appLocalizations.total,
          value: cabinManager.cabins.length,
        ),
      ],
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
      onTap: onTap,
      items: [
        StatisticSimpleItem(
          label: appLocalizations.total,
          value: dayHandler.schoolYearManager.schoolYears.length,
        ),
        StatisticSimpleItem(
          label: appLocalizations.workingDays,
          value: dayHandler.schoolYearManager.totalWorkingDuration.inDays,
        ),
      ],
    );
  }
}

class _MostBookedDayStatistics extends StatelessWidget {
  final VoidCallback? onTap;

  const _MostBookedDayStatistics({super.key, this.onTap});

  @override
  Widget build(BuildContext context) {
    final appLocalizations = AppLocalizations.of(context)!;

    final cabinManager = Provider.of<CabinManager>(context);
    if (cabinManager.mostBookedDayEntry == null) return const SizedBox();

    final dayHandler = Provider.of<DayHandler>(context);

    return Statistics(
      title: appLocalizations.mostBookedDay,
      icon: Icons.calendar_today,
      onTap: onTap == null
          ? null
          : () {
              dayHandler.dateTime = cabinManager.mostBookedDayEntry!.key;
              onTap!.call();
            },
      items: [
        StatisticSimpleItem(
          value: DateFormat.d().add_MMM().add_y().format(
                cabinManager.mostBookedDayEntry!.key,
              ),
        ),
      ],
    );
  }
}

class _PopularTimesStatistics extends StatelessWidget {
  const _PopularTimesStatistics({super.key});

  @override
  Widget build(BuildContext context) {
    final appLocalizations = AppLocalizations.of(context)!;

    final cabinManager = Provider.of<CabinManager>(context);

    return Statistics(
      title: appLocalizations.popularTimes,
      icon: Icons.watch_later,
      items: [
        PopularTimesBarChart(
          timeRangesOccupancy:
              cabinManager.accumulatedTimeRangesOccupancy().fillEmptyKeyValues(
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
