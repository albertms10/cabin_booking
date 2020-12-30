import 'package:cabin_booking/model/cabin_manager.dart';
import 'package:cabin_booking/model/day_handler.dart';
import 'package:cabin_booking/utils/colors.dart';
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

    return Padding(
      padding: const EdgeInsets.all(32.0),
      child: Consumer2<DayHandler, CabinManager>(
        builder: (context, dayHandler, cabinManager, child) {
          return Column(
            children: [
              Row(
                children: [
                  Statistics(
                    title: appLocalizations.cabins,
                    items: [
                      StatisticItem(value: '${cabinManager.cabins.length}'),
                    ],
                  ),
                  const SizedBox(width: 32.0),
                  Statistics(
                    title: appLocalizations.bookings,
                    items: [
                      StatisticItem(
                        label: appLocalizations.total,
                        value: '${cabinManager.allBookingsCount}',
                      ),
                      StatisticItem(
                        label: appLocalizations.bookings,
                        value: '${cabinManager.bookingsCount}',
                      ),
                      StatisticItem(
                        label: appLocalizations.recurringBookings,
                        value: '${cabinManager.recurringBookingsCount}',
                      ),
                    ],
                  ),
                  const SizedBox(width: 32.0),
                  if (cabinManager.mostBookedDayEntry != null)
                    Statistics(
                      title: appLocalizations.mostBookedDay,
                      items: [
                        StatisticItem(
                          value: DateFormat.d().add_MMM().add_y().format(
                                cabinManager.mostBookedDayEntry.key,
                              ),
                        ),
                      ],
                    ),
                ],
              ),
              const SizedBox(height: 32.0),
              Row(
                children: [
                  Expanded(
                    child: HeatMapCalendar(
                      input: cabinManager.allCabinsBookingsCountPerDay,
                      dayValueWrapper: (value) =>
                          '${AppLocalizations.of(context).nBookings(value)}',
                      showLegend: true,
                      colorThresholds: mapColorsToHighestValue(
                        highestValue:
                            cabinManager.mostBookedDayEntry?.value ?? 1,
                        color: Theme.of(context).accentColor,
                      ),
                      onDayTap: (dateTime, value) {
                        dayHandler.dateTime = dateTime;
                        setRailPage(AppPages.Bookings);
                      },
                    ),
                  ),
                ],
              )
            ],
          );
        },
      ),
    );
  }
}
