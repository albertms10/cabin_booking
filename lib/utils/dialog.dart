import 'package:cabin_booking/model.dart';
import 'package:cabin_booking/widgets/booking/booking_dialog.dart';
import 'package:flutter/material.dart';

/// Shows a new dialog to create a new booking.
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
      return cabinManager.addRecurringBooking(newBooking.cabinId, newBooking);
    }

    if (newBooking is SingleBooking) {
      return cabinManager.addSingleBooking(newBooking.cabinId, newBooking);
    }
  }
}
