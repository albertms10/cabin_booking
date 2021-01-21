import 'package:cabin_booking/constants.dart';
import 'package:cabin_booking/model/booking.dart';
import 'package:cabin_booking/model/cabin.dart';
import 'package:cabin_booking/model/cabin_manager.dart';
import 'package:cabin_booking/model/recurring_booking.dart';
import 'package:cabin_booking/widgets/booking/booking_popup_menu.dart';
import 'package:cabin_booking/widgets/booking/booking_status_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import 'package:timer_builder/timer_builder.dart';

class BookingCard extends StatelessWidget {
  final Cabin cabin;
  final Booking booking;

  const BookingCard({
    Key key,
    @required this.cabin,
    @required this.booking,
  }) : super(key: key);

  double get height => booking.duration.inMinutes * kBookingHeightRatio - 16.0;

  bool get isRecurring => RecurringBooking.isRecurringBooking(booking);

  @override
  Widget build(BuildContext context) {
    return TimerBuilder.periodic(
      const Duration(minutes: 1),
      builder: (context) {
        final isBeforeNow = booking.endDateTime.isBefore(DateTime.now());

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
                  color: Colors.grey[300].withOpacity(isBeforeNow ? 0.41 : 1.0),
                  width: 1.5,
                ),
              ),
              color: Colors.transparent,
              child: Container(
                height: value,
                padding: const EdgeInsets.only(
                  top: 8.0,
                  right: 4.0,
                  bottom: 0.0,
                  left: 10.0,
                ),
                decoration: BoxDecoration(
                  color: Theme.of(context)
                      .cardColor
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
            Row(
              children: [
                if (isRecurring)
                  Tooltip(
                    message:
                        '${booking.recurringNumber}/${booking.recurringTotalTimes}',
                    child: Padding(
                      padding: const EdgeInsets.only(right: 4.0),
                      child: Icon(
                        Icons.repeat,
                        color: theme.hintColor,
                        size: 16.0,
                      ),
                    ),
                  ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        booking.description,
                        style: TextStyle(
                            fontSize: constraints.maxHeight > 20.0
                                ? 14.0
                                : constraints.maxHeight * 0.5),
                      ),
                      if (constraints.maxHeight > 30.0)
                        Text(
                          booking.timeRange,
                          style: theme.textTheme.caption.copyWith(
                            fontSize: constraints.maxHeight > 40.0
                                ? 14.0
                                : constraints.maxHeight * 0.4,
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(
              height: double.infinity,
              child: Wrap(
                direction: Axis.vertical,
                alignment: WrapAlignment.spaceBetween,
                spacing: -8.0,
                runAlignment: WrapAlignment.center,
                runSpacing: -8.0,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  BookingPopupMenu(
                    cabin: cabin,
                    booking: booking,
                  ),
                  BookingStatusButton(
                    status: booking.status,
                    onPressed: () {
                      Provider.of<CabinManager>(context, listen: false)
                          .modifyBookingStatusById(
                        cabin.id,
                        booking.id,
                        BookingStatus.values[(booking.status.index + 1) %
                            BookingStatus.values.length],
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
