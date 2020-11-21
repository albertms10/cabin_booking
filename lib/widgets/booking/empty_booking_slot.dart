import 'package:cabin_booking/constants.dart';
import 'package:cabin_booking/model/booking.dart';
import 'package:cabin_booking/model/cabin.dart';
import 'package:cabin_booking/model/cabin_manager.dart';
import 'package:cabin_booking/widgets/booking/booking_dialog.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EmptyBookingSlot extends StatelessWidget {
  final Cabin cabin;
  final DateTime dateStart;
  final DateTime dateEnd;

  EmptyBookingSlot({
    @required this.cabin,
    @required this.dateStart,
    @required this.dateEnd,
  });

  @override
  Widget build(BuildContext context) {
    final cabinManager = Provider.of<CabinManager>(context);

    final duration = dateEnd.difference(dateStart);

    return SizedBox(
      width: double.infinity,
      height: duration.inMinutes * bookingHeightRatio,
      child: duration.compareTo(minSlotDuration) < 0
          ? null
          : Container(
              margin: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(4)),
              ),
              child: Tooltip(
                message: '${duration.inMinutes} min',
                child: InkWell(
                  borderRadius: BorderRadius.all(Radius.circular(4)),
                  onTap: () async {
                    final _booking = await showDialog<Booking>(
                      context: context,
                      builder: (context) => BookingDialog(
                        Booking(
                          dateStart: dateStart,
                          dateEnd: dateEnd,
                          cabinId: cabin.id,
                        ),
                      ),
                    );

                    if (_booking != null)
                      cabinManager.addBooking(cabin.id, _booking);
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
