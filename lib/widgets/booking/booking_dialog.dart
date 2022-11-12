import 'package:cabin_booking/model.dart';
import 'package:cabin_booking/widgets/booking/booking_form.dart';
import 'package:cabin_booking/widgets/layout/data_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class BookingDialog extends StatefulWidget {
  final Booking booking;

  const BookingDialog({super.key, required this.booking});

  @override
  State<BookingDialog> createState() => _BookingDialogState();
}

class _BookingDialogState extends State<BookingDialog> {
  late bool _isRecurring = RecurringBooking.isRecurringBooking(widget.booking);

  void _setIsRecurring(bool isRecurring) {
    setState(() => _isRecurring = isRecurring);
  }

  @override
  Widget build(BuildContext context) {
    final appLocalizations = AppLocalizations.of(context)!;

    return DataDialog(
      title: Text(
        widget.booking.isLocked
            ? appLocalizations.lockedRange
            : _isRecurring
                ? appLocalizations.recurringBooking
                : appLocalizations.booking,
      ),
      content: SizedBox(
        width: 320,
        child: BookingForm(
          booking: widget.booking,
          isRecurring: _isRecurring,
          setIsRecurring: _setIsRecurring,
        ),
      ),
    );
  }
}
