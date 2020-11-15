import 'package:cabin_booking/l10n/app_localizations.dart';
import 'package:cabin_booking/widgets/booking/booking_form.dart';
import 'package:flutter/material.dart';

class BookingDialog extends StatelessWidget {
  final int cabinNumber;
  final DateTime startDate;
  final DateTime endDate;

  BookingDialog({
    this.cabinNumber,
    this.startDate,
    this.endDate,
  });

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      title: Text(AppLocalizations.of(context).booking),
      contentPadding: const EdgeInsets.all(24),
      children: [
        BookingForm(
          startDate: startDate,
          endDate: endDate,
        ),
      ],
    );
  }
}
