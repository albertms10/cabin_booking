import 'package:cabin_booking/model.dart';
import 'package:cabin_booking/utils/color_extension.dart';
import 'package:cabin_booking/utils/date_time_extension.dart';
import 'package:cabin_booking/widgets/layout/radio_button_list.dart';
import 'package:cabin_booking/widgets/standalone/heat_map_calendar/heat_map_calendar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

class BookingsHeatMapCalendar extends StatelessWidget {
  final VoidCallback? onDayTap;

  const BookingsHeatMapCalendar({super.key, this.onDayTap});

  @override
  Widget build(BuildContext context) {
    final appLocalizations = AppLocalizations.of(context)!;

    return Consumer2<DayHandler, CabinCollection>(
      builder: (context, dayHandler, cabinCollection, child) {
        final schoolYear = dayHandler.schoolYearCollection.schoolYear;

        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: HeatMapCalendar(
                input: cabinCollection.allCabinsBookingsCountPerDay,
                colorThresholds:
                    Theme.of(context).colorScheme.secondary.opacityThresholds(
                          highestValue:
                              cabinCollection.mostBookedDayEntry?.value ?? 1,
                          samples: 8,
                        ),
                firstWeekDay: DateTime.monday,
                onDayTap: onDayTap == null
                    ? null
                    : (dateTime, value) {
                        dayHandler.dateTime = dateTime;
                        onDayTap!.call();
                      },
                dayValueWrapper: appLocalizations.nBookings,
                showLegend: true,
                legendLessLabel: appLocalizations.less,
                legendMoreLabel: appLocalizations.more,
                firstDate: schoolYear?.startDate,
                lastDate: schoolYear?.endDate,
                highlightToday: true,
                highlightOn: (date) => date.isSameDateAs(dayHandler.dateTime),
              ),
            ),
            const SizedBox(width: 16),
            RadioButtonList(
              itemCount: dayHandler.schoolYearCollection.schoolYears.length,
              itemBuilder: (context, index) {
                return Text(
                  dayHandler.schoolYearCollection.schoolYears
                      .elementAt(index)
                      .toString(),
                );
              },
              initialIndex: dayHandler.schoolYearCollection.schoolYearIndex,
              onChanged: (index) => dayHandler.schoolYearIndex = index,
              reverse: true,
            ),
          ],
        );
      },
    );
  }
}
