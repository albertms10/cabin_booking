import 'package:cabin_booking/model.dart';
import 'package:cabin_booking/widgets/booking/booking_card.dart';
import 'package:cabin_booking/widgets/booking/booking_card_info.dart';
import 'package:cabin_booking/widgets/booking/booking_card_layout.dart';
import 'package:cabin_booking/widgets/booking/booking_preview_panel_overlay.dart';
import 'package:cabin_booking/widgets/layout/scrollable_time_table.dart';
import 'package:flutter/material.dart';

class DraggableBookingCard extends StatelessWidget {
  final Cabin cabin;
  final Booking booking;
  final ShowPreviewOverlayCallback? showPreviewPanel;
  final SetPreventTimeTableScroll? setPreventTimeTableScroll;

  const DraggableBookingCard({
    super.key,
    required this.cabin,
    required this.booking,
    this.showPreviewPanel,
    this.setPreventTimeTableScroll,
  });

  @override
  Widget build(BuildContext context) {
    final height = BookingCard.heightFromDuration(booking.duration);
    const outerInsets = BookingCardLayout.outerInset * 2;

    return LayoutBuilder(
      builder: (context, constraints) {
        return SizedBox(
          width: double.infinity,
          child: Draggable<String>(
            feedback: BookingCardLayout(
              booking: booking,
              width: constraints.maxWidth - outerInsets,
              height: height,
              elevation: 12,
              child: BookingCardInfo(cabin: cabin, booking: booking),
            ),
            data: booking.id,
            childWhenDragging: SizedBox(height: height + outerInsets),
            maxSimultaneousDrags: 1,
            ignoringFeedbackSemantics: false,
            child: BookingCard(
              key: Key(booking.id),
              cabin: cabin,
              booking: booking,
              showPreviewPanel: showPreviewPanel,
              setPreventTimeTableScroll: setPreventTimeTableScroll,
            ),
          ),
        );
      },
    );
  }
}
