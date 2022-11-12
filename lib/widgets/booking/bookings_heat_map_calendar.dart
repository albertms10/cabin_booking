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

    return Consumer2<DayHandler, CabinManager>(
      builder: (context, dayHandler, cabinManager, child) {
        final schoolYear = dayHandler.schoolYearManager.schoolYear;

        return Row(
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
                      highestValue: cabinManager.mostBookedDayEntry?.value ?? 1,
                      samples: 8,
                    ),
                firstWeekDay: DateTime.monday,
                firstDate: schoolYear?.startDate,
                lastDate: schoolYear?.endDate,
                highlightToday: true,
                highlightOn: (date) => date.isSameDateAs(dayHandler.dateTime),
                onDayTap: onDayTap == null
                    ? null
                    : (dateTime, value) {
                        dayHandler.dateTime = dateTime;
                        onDayTap!.call();
                      },
                legendLessLabel: appLocalizations.less,
                legendMoreLabel: appLocalizations.more,
              ),
            ),
            const SizedBox(width: 16),
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
        );
      },
    );
  }
}
