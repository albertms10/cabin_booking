import 'package:cabin_booking/constants.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:cabin_booking/model/booking.dart';
import 'package:cabin_booking/model/cabin_manager.dart';
import 'package:cabin_booking/model/day_handler.dart';
import 'package:cabin_booking/model/recurring_booking.dart';
import 'package:cabin_booking/utils/show_booking_dialog.dart';
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
          onPressed: () {
            showNewBookingDialog(
              context,
              Booking(
                date: dayHandler.dateTime,
                timeStart: timeTableStartTime,
                timeEnd: TimeOfDay(
                  hour: timeTableStartTime.hour + 1,
                  minute: timeTableStartTime.minute,
                ),
                cabinId: cabinManager.cabins.first.id,
              ),
              cabinManager,
            );
          },
          children: [
            FloatingActionButtonMenuChild(
              icon: Icons.repeat,
              label: AppLocalizations.of(context).recurringBooking,
              onTap: () {
                showNewBookingDialog(
                  context,
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
                  cabinManager,
                );
              },
            ),
            FloatingActionButtonMenuChild(
              icon: Icons.lock,
              label: AppLocalizations.of(context).lockedRange,
              onTap: () {
                showNewBookingDialog(
                  context,
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
