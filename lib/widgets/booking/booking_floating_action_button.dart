import 'package:cabin_booking/constants.dart';
import 'package:cabin_booking/l10n/app_localizations.dart';
import 'package:cabin_booking/model/booking.dart';
import 'package:cabin_booking/model/cabin_manager.dart';
import 'package:cabin_booking/model/day_handler.dart';
import 'package:cabin_booking/utils/time_of_day.dart';
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
          marginBottom: 24,
          marginRight: 24,
          animatedIcon: AnimatedIcons.add_event,
          animatedIconTheme: IconThemeData(size: 28),
          label: AppLocalizations.of(context).booking,
          onPress: () async {
            final _booking = await showDialog<Booking>(
              context: context,
              builder: (context) => BookingDialog(
                Booking(
                  dateStart: tryParseDateTimeWithFormattedTimeOfDay(
                    dateTime: dayHandler.dateTime,
                    formattedTimeOfDay: timeTableStartTime.format(context),
                  ),
                  dateEnd: tryParseDateTimeWithFormattedTimeOfDay(
                    dateTime: dayHandler.dateTime,
                    formattedTimeOfDay: TimeOfDay(
                      hour: timeTableStartTime.hour + 1,
                      minute: timeTableStartTime.minute,
                    ).format(context),
                  ),
                  cabinId: cabinManager.cabins.first.id,
                ),
              ),
            );

            if (_booking != null)
              cabinManager.addBooking(_booking.cabinId, _booking);
          },
          children: [
            FloatingActionButtonMenuChild(
              icon: Icons.repeat,
              label: AppLocalizations.of(context).recurringBooking,
            ),
            FloatingActionButtonMenuChild(
              icon: Icons.lock,
              label: AppLocalizations.of(context).lockedRange,
            ),
          ],
        );
      },
    );
  }
}
