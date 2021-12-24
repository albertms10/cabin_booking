import 'package:cabin_booking/constants.dart';
import 'package:cabin_booking/model.dart';
import 'package:cabin_booking/widgets/booking/booking_preview_panel_overlay.dart';
import 'package:cabin_booking/widgets/booking/bookings_stack.dart';
import 'package:cabin_booking/widgets/layout/current_time_indicator.dart';
import 'package:cabin_booking/widgets/layout/striped_background.dart';
import 'package:flutter/material.dart';

class BookingsTable extends StatelessWidget {
  final Set<Cabin> cabins;
  final DateTime dateTime;
  final ShowPreviewOverlayCallback? showPreviewPanel;
  final double stackWidth;

  const BookingsTable({
    Key? key,
    required this.cabins,
    required this.dateTime,
    this.showPreviewPanel,
    required this.stackWidth,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Stack(
        children: [
          const StripedBackground(
            startTime: kTimeTableStartTime,
            endTime: kTimeTableEndTime,
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              for (final cabin in cabins)
                SizedBox(
                  width: stackWidth,
                  child: BookingsStack(
                    key: Key('${cabin.number}'),
                    cabin: cabin.simplified(),
                    bookings: cabin.allBookingsOn(dateTime),
                    showPreviewPanel: showPreviewPanel,
                  ),
                ),
            ],
          ),
          const CurrentTimeIndicator(hideText: true),
        ],
      ),
    );
  }
}
