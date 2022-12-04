import 'package:cabin_booking/model.dart';
import 'package:cabin_booking/widgets/booking/booking_preview_panel_action_bar.dart';
import 'package:cabin_booking/widgets/booking/booking_preview_panel_row.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class BookingPreviewPanel extends StatelessWidget {
  final Cabin cabin;
  final Booking booking;
  final VoidCallback? onClose;

  const BookingPreviewPanel({
    required this.cabin,
    required this.booking,
    super.key,
    this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          BookingPreviewPanelActionBar(
            cabin: cabin,
            booking: booking,
            onClose: onClose,
          ),
          _BookingPreviewPanelHeadline(booking: booking),
          const SizedBox(height: 32),
        ],
      ),
    );
  }
}

class _BookingPreviewPanelHeadline extends StatelessWidget {
  final Booking booking;

  const _BookingPreviewPanelHeadline({super.key, required this.booking});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BookingPreviewPanelRow.headline(
      trailing: booking.isLocked
          ? const Icon(Icons.lock_outline)
          : RecurringBooking.isRecurringBooking(booking)
              ? const Icon(Icons.repeat)
              : Container(
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primary,
                    borderRadius: const BorderRadius.all(Radius.circular(4)),
                  ),
                  width: 14,
                  height: 14,
                ),
      headline: booking.description!,
      description: Row(
        children: [
          Text(DateFormat.MMMMEEEEd().format(booking.dateOnly!)),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Text(
              '·',
              style: TextStyle(color: theme.hintColor),
            ),
          ),
          Text(booking.timeRange),
        ],
      ),
    );
  }
}
