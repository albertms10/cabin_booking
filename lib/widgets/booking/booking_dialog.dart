import 'package:cabin_booking/l10n/app_localizations.dart';
import 'package:cabin_booking/model/booking.dart';
import 'package:cabin_booking/model/recurring_booking.dart';
import 'package:cabin_booking/widgets/booking/booking_form.dart';
import 'package:cabin_booking/widgets/layout/data_dialog.dart';
import 'package:flutter/material.dart';

class BookingDialog extends StatelessWidget {
  final Booking booking;

  BookingDialog(this.booking);

  @override
  Widget build(BuildContext context) {
    return DataDialog(
      title: Text(
        booking.isDisabled
            ? AppLocalizations.of(context).lockedRange
            : booking is RecurringBooking || booking.recurringBookingId != null
                ? AppLocalizations.of(context).recurringBooking
                : AppLocalizations.of(context).booking,
      ),
      content: SizedBox(
        width: 250.0,
        child: BookingForm(booking),
      ),
    );
  }
}
