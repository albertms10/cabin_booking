import 'package:cabin_booking/model/booking.dart';
import 'package:cabin_booking/model/recurring_booking.dart';
import 'package:cabin_booking/widgets/booking/booking_form.dart';
import 'package:cabin_booking/widgets/layout/data_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class BookingDialog extends StatefulWidget {
  final Booking booking;

  BookingDialog(this.booking);

  @override
  _BookingDialogState createState() => _BookingDialogState();
}

class _BookingDialogState extends State<BookingDialog> {
  bool _isRecurring = false;

  @override
  void initState() {
    super.initState();

    _isRecurring = widget.booking is RecurringBooking ||
        widget.booking.recurringBookingId != null;
  }

  void setIsRecurring(bool isRecurring) {
    setState(() => _isRecurring = isRecurring);
  }

  @override
  Widget build(BuildContext context) {
    return DataDialog(
      title: Text(
        widget.booking.isDisabled
            ? AppLocalizations.of(context).lockedRange
            : _isRecurring
                ? AppLocalizations.of(context).recurringBooking
                : AppLocalizations.of(context).booking,
      ),
      content: SizedBox(
        width: 250.0,
        child: BookingForm(
          widget.booking,
          isRecurring: _isRecurring,
          setIsRecurring: setIsRecurring,
        ),
      ),
    );
  }
}
