import 'package:cabin_booking/model.dart';
import 'package:cabin_booking/widgets/booking/booking_preview_panel_action_bar.dart';
import 'package:cabin_booking/widgets/booking/booking_preview_panel_row.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart';

class BookingPreviewPanel extends StatelessWidget {
  final Cabin cabin;
  final Booking booking;
  final VoidCallback? onClose;

  const BookingPreviewPanel({
    required this.cabin,
    required this.booking,
    Key? key,
    this.onClose,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final appLocalizations = AppLocalizations.of(context)!;

    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          BookingPreviewPanelActionBar(
            cabin: cabin,
            booking: booking,
            onClose: onClose,
          ),
          _BookingPreviewPanelHeadline(booking: booking),
          const SizedBox(height: 28.0),
          BookingPreviewPanelRow(
            trailing: Icon(booking.status.icon),
            child: Text(booking.status.localized(appLocalizations)),
          ),
          const SizedBox(height: 32.0),
        ],
      ),
    );
  }
}

class _BookingPreviewPanelHeadline extends StatelessWidget {
  final Booking booking;

  const _BookingPreviewPanelHeadline({Key? key, required this.booking})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BookingPreviewPanelRow.headline(
      trailing: booking.isLocked
          ? const Icon(Icons.lock_outline)
          : RecurringBooking.isRecurringBooking(booking)
              ? const Icon(Icons.repeat)
              : Container(
                  width: 14.0,
                  height: 14.0,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary,
                    borderRadius: const BorderRadius.all(Radius.circular(4.0)),
                  ),
                ),
      headline: booking.description!,
      description: Row(
        children: [
          Text(DateFormat.MMMMEEEEd().format(booking.date!)),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Text(
              '·',
              style: TextStyle(color: Theme.of(context).hintColor),
            ),
          ),
          Text(booking.timeRange),
        ],
      ),
    );
  }
}
