import 'package:cabin_booking/l10n/app_localizations.dart';
import 'package:cabin_booking/model/booking.dart';
import 'package:cabin_booking/widgets/booking/booking_form.dart';
import 'package:flutter/material.dart';

class BookingDialog extends StatelessWidget {
  final Booking booking;

  BookingDialog(this.booking);

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      title: Row(children: [
        IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
          splashRadius: 24,
        ),
        const SizedBox(width: 8),
        Text(AppLocalizations.of(context).booking)
      ]),
      contentPadding: const EdgeInsets.only(left: 24, right: 24, bottom: 24),
      titlePadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 18),
      children: [
        BookingForm(booking),
      ],
    );
  }
}
