import 'package:cabin_booking/constants.dart';
import 'package:cabin_booking/model.dart';
import 'package:cabin_booking/utils/date_time_extension.dart';
import 'package:cabin_booking/utils/dialog.dart';
import 'package:cabin_booking/utils/time_of_day_extension.dart';
import 'package:cabin_booking/widgets/standalone/floating_action_button/floating_action_button_menu.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

class BookingFloatingActionButton extends StatelessWidget {
  const BookingFloatingActionButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer2<DayHandler, CabinCollection>(
      builder: (context, dayHandler, cabinCollection, child) {
        if (cabinCollection.cabins.isEmpty) return const SizedBox();

        final theme = Theme.of(context);
        final appLocalizations = AppLocalizations.of(context)!;

        return FloatingActionButtonMenu(
          buttons: [
            FloatingActionButtonMenuChild(
              label: Text(
                appLocalizations.recurringBooking,
                style: theme.textTheme.titleSmall,
              ),
              icon: Icons.repeat,
              onTap: () {
                showNewBookingDialog(
                  context: context,
                  booking: RecurringBooking(
                    startDate: dayHandler.dateTime
                        .addLocalTimeOfDay(kTimeTableStartTime),
                    endDate: dayHandler.dateTime.addLocalTimeOfDay(
                      kTimeTableStartTime.increment(
                        minutes: defaultSlotDuration.inMinutes,
                      ),
                    ),
                    cabin: cabinCollection.cabins.first,
                    occurrences: 1,
                  ),
                  cabinCollection: cabinCollection,
                );
              },
            ),
            FloatingActionButtonMenuChild(
              label: Text(
                appLocalizations.lockedRange,
                style: theme.textTheme.titleSmall,
              ),
              icon: Icons.lock,
              onTap: () {
                showNewBookingDialog(
                  context: context,
                  booking: SingleBooking(
                    startDate: dayHandler.dateTime
                        .addLocalTimeOfDay(kTimeTableStartTime),
                    endDate: dayHandler.dateTime.addLocalTimeOfDay(
                      kTimeTableStartTime.increment(
                        minutes: defaultSlotDuration.inMinutes,
                      ),
                    ),
                    isLocked: true,
                    cabin: cabinCollection.cabins.first,
                  ),
                  cabinCollection: cabinCollection,
                );
              },
            ),
          ],
          label: Text(
            appLocalizations.booking,
            style: theme.textTheme.titleSmall,
          ),
          animatedIcon: AnimatedIcons.add_event,
          animatedIconTheme:
              IconThemeData(size: 25, color: theme.colorScheme.onPrimary),
          onPressed: () {
            showNewBookingDialog(
              context: context,
              booking: SingleBooking(
                startDate:
                    dayHandler.dateTime.addLocalTimeOfDay(kTimeTableStartTime),
                endDate: dayHandler.dateTime.addLocalTimeOfDay(
                  kTimeTableStartTime.increment(
                    minutes: defaultSlotDuration.inMinutes,
                  ),
                ),
                cabin: cabinCollection.cabins.first,
              ),
              cabinCollection: cabinCollection,
            );
          },
        );
      },
    );
  }
}
