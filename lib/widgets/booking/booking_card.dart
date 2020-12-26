import 'package:cabin_booking/constants.dart';
import 'package:cabin_booking/model/booking.dart';
import 'package:cabin_booking/model/cabin.dart';
import 'package:cabin_booking/model/recurring_booking.dart';
import 'package:cabin_booking/widgets/booking/booking_popup_menu.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:timer_builder/timer_builder.dart';

class BookingCard extends StatelessWidget {
  final Cabin cabin;
  final Booking booking;

  const BookingCard({
    Key key,
    @required this.cabin,
    @required this.booking,
  }) : super(key: key);

  double get height => booking.duration.inMinutes * bookingHeightRatio - 16.0;

  bool get isRecurring =>
      booking is RecurringBooking || booking.recurringBookingId != null;

  @override
  Widget build(BuildContext context) {
    return TimerBuilder.periodic(
      const Duration(minutes: 1),
      builder: (context) {
        final isBeforeNow = booking.dateEnd.isBefore(DateTime.now());

        return Card(
          margin: const EdgeInsets.all(8.0),
          shadowColor: isBeforeNow ? Colors.black38 : Colors.black87,
          elevation: 0.0,
          shape: RoundedRectangleBorder(
            borderRadius: const BorderRadius.all(Radius.circular(10.0)),
            side: BorderSide(
              color: (isRecurring ? Colors.blue[200] : Colors.grey[300])
                  .withAlpha(isBeforeNow ? 100 : 255),
              width: 1.5,
            ),
          ),
          color: Colors.transparent,
          child: Container(
            height: height,
            padding: const EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              color: (isRecurring ? Colors.blue[50] : Colors.white)
                  .withAlpha(isBeforeNow ? 100 : 255),
              borderRadius: const BorderRadius.all(Radius.circular(10.0)),
            ),
            child: BookingCardInfo(
              cabin: cabin,
              booking: booking,
              isRecurring: isRecurring,
            ),
          ),
        );
      },
    );
  }
}

class BookingCardInfo extends StatelessWidget {
  final Cabin cabin;
  final Booking booking;
  final bool isRecurring;

  const BookingCardInfo({
    @required this.cabin,
    @required this.booking,
    this.isRecurring = false,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Stack(
          alignment: Alignment.topRight,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  booking.description,
                  style: TextStyle(
                      fontSize: constraints.maxHeight > 20
                          ? 14.0
                          : constraints.maxHeight * 0.5),
                ),
                Row(
                  children: [
                    if (constraints.maxHeight > 30)
                      Text(
                        booking.timeRange,
                        style: TextStyle(
                          color: Colors.black38,
                          fontSize: constraints.maxHeight > 40
                              ? 14.0
                              : constraints.maxHeight * 0.4,
                        ),
                      ),
                    if (isRecurring && constraints.maxHeight > 30)
                      Text(
                        ' · ${booking.recurringNumber}/${booking.recurringTotalTimes}',
                        style: Theme.of(context).textTheme.caption.copyWith(
                              color: Colors.black38,
                              fontSize: constraints.maxHeight > 40
                                  ? 14.0
                                  : constraints.maxHeight * 0.4,
                            ),
                      ),
                  ],
                ),
              ],
            ),
            BookingPopupMenu(
              cabin: cabin,
              booking: booking,
            ),
          ],
        );
      },
    );
  }
}
