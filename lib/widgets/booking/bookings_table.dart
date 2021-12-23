import 'package:cabin_booking/constants.dart';
import 'package:cabin_booking/model.dart';
import 'package:cabin_booking/widgets/booking/booking_preview_panel_overlay.dart';
import 'package:cabin_booking/widgets/booking/bookings_stack.dart';
import 'package:cabin_booking/widgets/layout/current_time_indicator.dart';
import 'package:cabin_booking/widgets/layout/striped_background.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BookingsTable extends StatelessWidget {
  final ShowPreviewOverlayCallback? showPreviewPanel;

  const BookingsTable({
    Key? key,
    this.showPreviewPanel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: LayoutBuilder(
        builder: (context, constraints) {
          return Stack(
            children: [
              const StripedBackground(
                startTime: kTimeTableStartTime,
                endTime: kTimeTableEndTime,
              ),
              Consumer2<DayHandler, CabinManager>(
                builder: (context, dayHandler, cabinManager, child) {
                  final maxParentWidth = constraints.maxWidth;
                  final calculatedBookingStackWidth =
                      maxParentWidth / cabinManager.cabins.length;
                  final bookingStackWidth =
                      (calculatedBookingStackWidth < kBookingColumnMinWidth)
                          ? kBookingColumnMinWidth
                          : calculatedBookingStackWidth;

                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      for (final cabin in cabinManager.cabins)
                        SizedBox(
                          width: bookingStackWidth,
                          child: BookingsStack(
                            key: Key('${cabin.number}'),
                            cabin: cabin.simplified(),
                            bookings: cabin.allBookingsOn(dayHandler.dateTime),
                            showPreviewPanel: showPreviewPanel,
                          ),
                        ),
                    ],
                  );
                },
              ),
              const CurrentTimeIndicator(hideText: true),
            ],
          );
        },
      ),
    );
  }
}
