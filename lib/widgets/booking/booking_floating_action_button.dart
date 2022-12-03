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
    return Consumer2<DayHandler, CabinManager>(
      builder: (context, dayHandler, cabinManager, child) {
        if (cabinManager.cabins.isEmpty) return const SizedBox();

        final theme = Theme.of(context);
        final appLocalizations = AppLocalizations.of(context)!;

        return FloatingActionButtonMenu(
          buttons: [
            FloatingActionButtonMenuChild(
              label: Text(
                appLocalizations.recurringBooking,
                style: theme.textTheme.subtitle2,
              ),
              icon: Icons.repeat,
              onTap: () {
                showNewBookingDialog(
                  context: context,
                  booking: RecurringBooking(
                    startDateTime:
                        dayHandler.dateTime.addTimeOfDay(kTimeTableStartTime),
                    endDateTime: dayHandler.dateTime.addTimeOfDay(
                      kTimeTableStartTime.increment(
                        minutes: defaultSlotDuration.inMinutes,
                      ),
                    ),
                    cabinId: cabinManager.cabins.first.id,
                    occurrences: 1,
                  ),
                  cabinManager: cabinManager,
                );
              },
            ),
            FloatingActionButtonMenuChild(
              label: Text(
                appLocalizations.lockedRange,
                style: theme.textTheme.subtitle2,
              ),
              icon: Icons.lock,
              onTap: () {
                showNewBookingDialog(
                  context: context,
                  booking: SingleBooking(
                    startDateTime:
                        dayHandler.dateTime.addTimeOfDay(kTimeTableStartTime),
                    endDateTime: dayHandler.dateTime.addTimeOfDay(
                      kTimeTableStartTime.increment(
                        minutes: defaultSlotDuration.inMinutes,
                      ),
                    ),
                    isLocked: true,
                    cabinId: cabinManager.cabins.first.id,
                  ),
                  cabinManager: cabinManager,
                );
              },
            ),
          ],
          label: Text(
            appLocalizations.booking,
            style: theme.textTheme.subtitle2,
          ),
          animatedIcon: AnimatedIcons.add_event,
          animatedIconTheme:
              IconThemeData(color: theme.colorScheme.onPrimary, size: 25),
          onPressed: () {
            showNewBookingDialog(
              context: context,
              booking: SingleBooking(
                startDateTime:
                    dayHandler.dateTime.addTimeOfDay(kTimeTableStartTime),
                endDateTime: dayHandler.dateTime.addTimeOfDay(
                  kTimeTableStartTime.increment(
                    minutes: defaultSlotDuration.inMinutes,
                  ),
                ),
                cabinId: cabinManager.cabins.first.id,
              ),
              cabinManager: cabinManager,
            );
          },
        );
      },
    );
  }
}
