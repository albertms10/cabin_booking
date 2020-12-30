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

        return TweenAnimationBuilder<double>(
          tween: Tween<double>(begin: height, end: height),
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOutCubic,
          builder: (context, value, child) {
            return Card(
              margin: const EdgeInsets.all(8.0),
              shadowColor: isBeforeNow ? Colors.black38 : Colors.black87,
              elevation: 0.0,
              shape: RoundedRectangleBorder(
                borderRadius: const BorderRadius.all(Radius.circular(10.0)),
                side: BorderSide(
                  color: (isRecurring ? Colors.blue[200] : Colors.grey[300])
                      .withOpacity(isBeforeNow ? 0.41 : 1.0),
                  width: 1.5,
                ),
              ),
              color: Colors.transparent,
              child: Container(
                height: value,
                padding: const EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  color: (isRecurring
                          ? Colors.blue.withOpacity(0.41)
                          : Theme.of(context).cardColor)
                      .withOpacity(isBeforeNow ? 0.41 : 1.0),
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
    final theme = Theme.of(context);

    return LayoutBuilder(
      builder: (context, constraints) {
        return Stack(
          alignment: Alignment.topRight,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  booking.description,
                  style: TextStyle(
                      fontSize: constraints.maxHeight > 20
                          ? 14.0
                          : constraints.maxHeight * 0.5),
                ),
                if (constraints.maxHeight > 30)
                  Text(
                    booking.timeRange +
                        (isRecurring && constraints.maxHeight > 30
                            ? ' · ${booking.recurringNumber}/${booking.recurringTotalTimes}'
                            : ''),
                    style: theme.textTheme.caption.copyWith(
                      fontSize: constraints.maxHeight > 40
                          ? 14.0
                          : constraints.maxHeight * 0.4,
                    ),
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
