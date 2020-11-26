import 'package:cabin_booking/constants.dart';
import 'package:cabin_booking/model/booking.dart';
import 'package:cabin_booking/model/cabin.dart';
import 'package:cabin_booking/model/cabin_manager.dart';
import 'package:cabin_booking/widgets/booking/booking_dialog.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:timer_builder/timer_builder.dart';

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
    final cabinManager = Provider.of<CabinManager>(context, listen: false);

    return TimerBuilder.periodic(
      const Duration(seconds: 30),
      builder: (context) {
        final now = DateTime.now();

        final fullDuration = dateEnd.difference(dateStart);

        final startToNowDuration = now.difference(dateStart);
        final startsBeforeNow = now.compareTo(dateStart) > 0;

        final endToNowDuration = dateEnd.difference(now);
        final endsAfterNow = dateEnd.compareTo(now) > 0;

        final duration =
            startsBeforeNow && endsAfterNow ? endToNowDuration : fullDuration;

        final preciseDuration = (duration.inSeconds / 60).ceil();

        final start = startsBeforeNow ? now : dateStart;

        return Column(
          children: [
            if (startsBeforeNow && endsAfterNow)
              SizedBox(
                height: startToNowDuration.inMinutes * bookingHeightRatio,
              ),
            SizedBox(
              width: double.infinity,
              height: preciseDuration * bookingHeightRatio,
              child: duration.compareTo(minSlotDuration) < 0 ||
                      dateEnd.compareTo(now) < 0
                  ? null
                  : Container(
                      margin: const EdgeInsets.all(8.0),
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(4.0)),
                      ),
                      child: Tooltip(
                        message: '${preciseDuration} min',
                        child: InkWell(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(4.0)),
                          onTap: () async {
                            final newBooking = await showDialog<Booking>(
                              context: context,
                              builder: (context) => BookingDialog(
                                Booking(
                                  date: start,
                                  timeStart: TimeOfDay.fromDateTime(start),
                                  timeEnd: TimeOfDay.fromDateTime(dateEnd),
                                  cabinId: cabin.id,
                                ),
                              ),
                            );

                            if (newBooking != null) {
                              cabinManager.addBooking(cabin.id, newBooking);
                            }
                          },
                          child: const Icon(
                            Icons.add,
                            size: 18.0,
                            color: Colors.black38,
                          ),
                        ),
                      ),
                    ),
            ),
          ],
        );
      },
    );
  }
}
