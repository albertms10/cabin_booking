import 'package:cabin_booking/constants.dart';
import 'package:cabin_booking/model/booking.dart';
import 'package:cabin_booking/model/cabin.dart';
import 'package:cabin_booking/widgets/booking/booking_dialog.dart';
import 'package:flutter/material.dart';

class EmptyBookingSlot extends StatelessWidget {
  final Cabin cabin;
  final DateTime startDate;
  final DateTime endDate;
  final Duration duration;

  EmptyBookingSlot({
    @required this.cabin,
    @required this.startDate,
    @required this.endDate,
    this.duration = maxSlotDuration,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: duration.inMinutes * bookingHeightRatio,
      child: Container(
        margin: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(4)),
        ),
        child: Tooltip(
          message: '${duration.inMinutes} min',
          child: InkWell(
            borderRadius: BorderRadius.all(Radius.circular(4)),
            onTap: () async {
              final booking = await showDialog<Booking>(
                context: context,
                builder: (context) => BookingDialog(
                  startDate: startDate,
                  endDate: endDate,
                ),
              );

              print(booking);
            },
            child: const Icon(
              Icons.add,
              size: 18,
              color: Colors.black38,
            ),
          ),
        ),
      ),
    );
  }
}
