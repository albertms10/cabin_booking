import 'package:cabin_booking/constants.dart';
import 'package:cabin_booking/model/booking.dart';
import 'package:cabin_booking/model/cabin_manager.dart';
import 'package:cabin_booking/model/day_handler.dart';
import 'package:cabin_booking/model/recurring_booking.dart';
import 'package:cabin_booking/utils/date.dart';
import 'package:cabin_booking/utils/show_booking_dialog.dart';
import 'package:cabin_booking/widgets/standalone/floating_action_button/floating_action_button_menu.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

class BookingFloatingActionButton extends StatelessWidget {
  const BookingFloatingActionButton();

  @override
  Widget build(BuildContext context) {
    return Consumer2<DayHandler, CabinManager>(
      builder: (context, dayHandler, cabinManager, child) {
        if (cabinManager.cabins.isEmpty) return const SizedBox();

        final theme = Theme.of(context);
        final appLocalizations = AppLocalizations.of(context);

        return FloatingActionButtonMenu(
          animatedIcon: AnimatedIcons.add_event,
          animatedIconTheme: IconThemeData(
            size: 25.0,
            color: Theme.of(context).colorScheme.onPrimary,
          ),
          label: Text(
            appLocalizations.booking,
            style: theme.textTheme.subtitle2,
          ),
          onPressed: () {
            showNewBookingDialog(
              context,
              Booking(
                date: dateOnly(dayHandler.dateTime),
                startTime: timeTableStartTime,
                endTime: timeTableStartTime.replacing(
                  hour: (timeTableStartTime.hour + 1) % TimeOfDay.hoursPerDay,
                ),
                cabinId: cabinManager.cabins.first.id,
              ),
              cabinManager,
            );
          },
          buttons: [
            FloatingActionButtonMenuChild(
              icon: Icons.repeat,
              label: Text(
                appLocalizations.recurringBooking,
                style: theme.textTheme.subtitle2,
              ),
              onTap: () {
                showNewBookingDialog(
                  context,
                  RecurringBooking(
                    date: dateOnly(dayHandler.dateTime),
                    startTime: timeTableStartTime,
                    endTime: timeTableStartTime.replacing(
                      hour:
                          (timeTableStartTime.hour + 1) % TimeOfDay.hoursPerDay,
                    ),
                    occurrences: 1,
                    cabinId: cabinManager.cabins.first.id,
                  ),
                  cabinManager,
                );
              },
            ),
            FloatingActionButtonMenuChild(
              icon: Icons.lock,
              label: Text(
                appLocalizations.lockedRange,
                style: theme.textTheme.subtitle2,
              ),
              onTap: () {
                showNewBookingDialog(
                  context,
                  Booking(
                    date: dateOnly(dayHandler.dateTime),
                    startTime: timeTableStartTime,
                    endTime: timeTableStartTime.replacing(
                      hour:
                          (timeTableStartTime.hour + 1) % TimeOfDay.hoursPerDay,
                    ),
                    isDisabled: true,
                    cabinId: cabinManager.cabins.first.id,
                  ),
                  cabinManager,
                );
              },
            ),
          ],
        );
      },
    );
  }
}
