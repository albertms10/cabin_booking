import 'package:cabin_booking/constants.dart';
import 'package:cabin_booking/l10n/app_localizations.dart';
import 'package:cabin_booking/model/booking.dart';
import 'package:cabin_booking/model/cabin_manager.dart';
import 'package:cabin_booking/model/day_handler.dart';
import 'package:cabin_booking/model/recurring_booking.dart';
import 'package:cabin_booking/widgets/booking/booking_dialog.dart';
import 'package:cabin_booking/widgets/custom/floating_action_button/floating_action_button_menu.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BookingFloatingActionButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer2<DayHandler, CabinManager>(
      builder: (context, dayHandler, cabinManager, child) {
        return FloatingActionButtonMenu(
          animatedIcon: AnimatedIcons.add_event,
          animatedIconTheme: IconThemeData(size: 25.0),
          label: AppLocalizations.of(context).booking,
          onPress: () async {
            final newBooking = await showDialog<Booking>(
              context: context,
              builder: (context) => BookingDialog(
                Booking(
                  date: dayHandler.dateTime,
                  timeStart: timeTableStartTime,
                  timeEnd: TimeOfDay(
                    hour: timeTableStartTime.hour + 1,
                    minute: timeTableStartTime.minute,
                  ),
                  cabinId: cabinManager.cabins.first.id,
                ),
              ),
            );

            if (newBooking != null) {
              cabinManager.addBooking(newBooking.cabinId, newBooking);
            }
          },
          children: [
            FloatingActionButtonMenuChild(
              icon: Icons.repeat,
              label: AppLocalizations.of(context).recurringBooking,
              onTap: () async {
                final newRecurringBooking = await showDialog<RecurringBooking>(
                  context: context,
                  builder: (context) => BookingDialog(
                    RecurringBooking(
                      date: dayHandler.dateTime,
                      timeStart: timeTableStartTime,
                      timeEnd: TimeOfDay(
                        hour: timeTableStartTime.hour + 1,
                        minute: timeTableStartTime.minute,
                      ),
                      times: 1,
                      cabinId: cabinManager.cabins.first.id,
                    ),
                  ),
                );

                if (newRecurringBooking != null) {
                  cabinManager.addRecurringBooking(
                      newRecurringBooking.cabinId, newRecurringBooking);
                }
              },
            ),
            FloatingActionButtonMenuChild(
              icon: Icons.lock,
              label: AppLocalizations.of(context).lockedRange,
              onTap: () async {
                final newBooking = await showDialog<Booking>(
                  context: context,
                  builder: (context) => BookingDialog(
                    Booking(
                      date: dayHandler.dateTime,
                      timeStart: timeTableStartTime,
                      timeEnd: TimeOfDay(
                        hour: timeTableStartTime.hour + 1,
                        minute: timeTableStartTime.minute,
                      ),
                      isDisabled: true,
                      cabinId: cabinManager.cabins.first.id,
                    ),
                  ),
                );

                if (newBooking != null) {
                  cabinManager.addBooking(newBooking.cabinId, newBooking);
                }
              },
            ),
          ],
        );
      },
    );
  }
}
