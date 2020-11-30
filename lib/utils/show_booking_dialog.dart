import 'package:cabin_booking/model/booking.dart';
import 'package:cabin_booking/model/cabin_manager.dart';
import 'package:cabin_booking/model/recurring_booking.dart';
import 'package:cabin_booking/widgets/booking/booking_dialog.dart';
import 'package:flutter/material.dart';

void showNewBookingDialog(
  BuildContext context,
  Booking booking,
  CabinManager cabinManager,
) async {
  final newBooking = await showDialog<Booking>(
    context: context,
    builder: (context) => BookingDialog(booking),
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
