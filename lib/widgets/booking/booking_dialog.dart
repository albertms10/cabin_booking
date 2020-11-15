import 'package:cabin_booking/l10n/app_localizations.dart';
import 'package:cabin_booking/model/cabin.dart';
import 'package:cabin_booking/widgets/booking/booking_form.dart';
import 'package:flutter/material.dart';

class BookingDialog extends StatelessWidget {
  final Cabin cabin;
  final DateTime startDate;
  final DateTime endDate;

  BookingDialog({
    this.cabin,
    this.startDate,
    this.endDate,
  });

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      title: Text(AppLocalizations.of(context).booking),
      contentPadding: EdgeInsets.all(24),
      children: [
        BookingForm(
          startDate: startDate,
          endDate: endDate,
        ),
      ],
    );
  }
}
