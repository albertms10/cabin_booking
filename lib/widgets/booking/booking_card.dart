import 'package:cabin_booking/app_styles.dart';
import 'package:cabin_booking/constants.dart';
import 'package:cabin_booking/model.dart';
import 'package:cabin_booking/widgets/booking/booking_card_info.dart';
import 'package:cabin_booking/widgets/booking/booking_card_layout.dart';
import 'package:cabin_booking/widgets/booking/booking_preview_panel_overlay.dart';
import 'package:cabin_booking/widgets/layout/scrollable_time_table.dart';
import 'package:flutter/material.dart';
import 'package:timer_builder/timer_builder.dart';

class BookingCard extends StatelessWidget {
  final Cabin cabin;
  final Booking booking;
  final ShowPreviewOverlayCallback? showPreviewPanel;
  final SetPreventTimeTableScroll? setPreventTimeTableScroll;

  const BookingCard({
    super.key,
    required this.cabin,
    required this.booking,
    this.showPreviewPanel,
    this.setPreventTimeTableScroll,
  });

  static double heightFromDuration(Duration duration) =>
      duration.inMinutes * kBookingHeightRatio - 16;

  @override
  Widget build(BuildContext context) {
    final height = heightFromDuration(booking.duration);

    return TimerBuilder.periodic(
      const Duration(minutes: 1),
      builder: (context) {
        return TweenAnimationBuilder<double>(
          tween: Tween<double>(begin: height, end: height),
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOutCubic,
          builder: (context, value, child) {
            return BookingCardLayout(
              booking: booking,
              height: height,
              child: _BookingCardInteractive(
                cabin: cabin,
                booking: booking,
                showPreviewPanel: showPreviewPanel,
                setPreventTimeTableScroll: setPreventTimeTableScroll,
                child: BookingCardInfo(cabin: cabin, booking: booking),
              ),
            );
          },
        );
      },
    );
  }
}

class _BookingCardInteractive extends StatelessWidget {
  final Cabin cabin;
  final Booking booking;
  final Widget child;
  final ShowPreviewOverlayCallback? showPreviewPanel;
  final SetPreventTimeTableScroll? setPreventTimeTableScroll;

  const _BookingCardInteractive({
    super.key,
    required this.cabin,
    required this.booking,
    required this.child,
    this.showPreviewPanel,
    this.setPreventTimeTableScroll,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: InkWell(
        onTap: () {
          final renderBox = context.findRenderObject() as RenderBox?;
          if (renderBox == null) return;
          showPreviewPanel?.call(
            cabin,
            booking,
            renderBox,
            setPreventTimeTableScroll,
          );
        },
        customBorder: const RoundedRectangleBorder(
          borderRadius: borderRadiusLarge,
        ),
        child: child,
      ),
    );
  }
}
