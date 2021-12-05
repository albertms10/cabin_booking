import 'package:cabin_booking/model.dart';
import 'package:cabin_booking/widgets/booking/booking_dialog.dart';
import 'package:flutter/material.dart';

Future<void> showNewBookingDialog({
  required BuildContext context,
  required Booking booking,
  required CabinManager cabinManager,
}) async {
  final newBooking = await showDialog<Booking>(
    context: context,
    builder: (context) => BookingDialog(booking: booking),
  );

  if (newBooking != null) {
    if (newBooking is RecurringBooking) {
      cabinManager.addRecurringBooking(
        newBooking.cabinId,
        newBooking,
      );
    } else {
      cabinManager.addBooking(newBooking.cabinId, newBooking);
    }
  }
}
