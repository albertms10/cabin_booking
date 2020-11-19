import 'package:cabin_booking/constants.dart';
import 'package:cabin_booking/model/booking.dart';
import 'package:cabin_booking/model/cabin.dart';
import 'package:cabin_booking/model/day_handler.dart';
import 'package:cabin_booking/utils/time_of_day.dart';
import 'package:cabin_booking/widgets/booking/booking_card.dart';
import 'package:cabin_booking/widgets/booking/empty_booking_slot.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BookingsStack extends StatelessWidget {
  final Cabin cabin;
  final List<Booking> bookings;

  BookingsStack({this.cabin, this.bookings = const <Booking>[]});

  List<Widget> _distributedBookings(BuildContext context) {
    final distributedBookings = <Widget>[];

    DayHandler _dayHandler = Provider.of<DayHandler>(context);

    final dateStart = tryParseDateTimeWithFormattedTimeOfDay(
      dateTime: _dayHandler.dateTime,
      formattedTimeOfDay: timeTableStartTime.format(context),
    );

    final dateEnd = tryParseDateTimeWithFormattedTimeOfDay(
      dateTime: _dayHandler.dateTime,
      formattedTimeOfDay: timeTableEndTime.format(context),
    );

    for (int i = -1; i < bookings.length; i++) {
      final isFirst = i == -1;
      final isLast = i == bookings.length - 1;

      DateTime currentBookingDate = isFirst ? dateStart : bookings[i].dateEnd;
      DateTime nextBookingDate = isLast ? dateEnd : bookings[i + 1].dateStart;

      final Duration duration = nextBookingDate.difference(currentBookingDate);
      final int durationMinutes = duration.inMinutes;

      if (!isFirst)
        distributedBookings.add(
          SizedBox(
            width: double.infinity,
            child: BookingCard(
              cabin: cabin,
              booking: bookings[i],
            ),
          ),
        );

      final runningSlotList = <EmptyBookingSlot>[];

      if (durationMinutes > 0) {
        int runningDurationMinutes = durationMinutes;

        while (runningDurationMinutes > maxSlotDuration.inMinutes) {
          nextBookingDate = currentBookingDate.add(maxSlotDuration);

          runningSlotList.add(
            EmptyBookingSlot(
              cabin: cabin,
              dateStart: currentBookingDate,
              dateEnd: nextBookingDate,
            ),
          );

          currentBookingDate = currentBookingDate.add(maxSlotDuration);

          runningDurationMinutes -= maxSlotDuration.inMinutes;
        }

        final Duration restDuration = Duration(minutes: runningDurationMinutes);

        nextBookingDate = currentBookingDate.add(restDuration);

        runningSlotList.add(
          EmptyBookingSlot(
            cabin: cabin,
            dateStart: currentBookingDate,
            dateEnd: nextBookingDate,
            duration: restDuration,
          ),
        );

        distributedBookings.addAll(runningSlotList);
      }
    }

    return distributedBookings;
  }

  @override
  Widget build(BuildContext context) {
    final distributedBookings = _distributedBookings(context);

    return Column(
      children: [
        for (Widget booking in distributedBookings) booking,
      ],
    );
  }
}
