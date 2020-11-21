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
          tooltip: MaterialLocalizations.of(context).backButtonTooltip,
          onPressed: () {
            Navigator.of(context).pop();
          },
          splashRadius: 24.0,
        ),
        const SizedBox(width: 8.0),
        Text(AppLocalizations.of(context).booking)
      ]),
      contentPadding:
          const EdgeInsets.only(left: 24.0, right: 24.0, bottom: 24.0),
      titlePadding:
          const EdgeInsets.symmetric(horizontal: 12.0, vertical: 18.0),
      children: [
        Container(
          width: 250.0,
          child: BookingForm(booking),
        ),
      ],
    );
  }
}
