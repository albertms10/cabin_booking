import 'package:cabin_booking/constants.dart';
import 'package:cabin_booking/model/booking.dart';
import 'package:cabin_booking/model/cabin.dart';
import 'package:cabin_booking/model/day_handler.dart';
import 'package:cabin_booking/utils/date.dart';
import 'package:cabin_booking/widgets/booking/booking_card.dart';
import 'package:cabin_booking/widgets/booking/disabled_booking_card.dart';
import 'package:cabin_booking/widgets/booking/empty_booking_slot.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BookingsStack extends StatelessWidget {
  final Cabin cabin;
  final Set<Booking> bookings;

  const BookingsStack({
    Key key,
    this.cabin,
    this.bookings = const <Booking>{},
  }) : super(key: key);

  Key _emptyBookingSlotKey(DateTime dateTime, int index) => Key(
        '${dateTime.toIso8601String().split('T').first}-'
        '$key-'
        '${index}',
      );

  List<Widget> _distributedBookings(BuildContext context) {
    final distributedBookings = <Widget>[];

    final dayHandler = Provider.of<DayHandler>(context);

    final dateStart = tryParseDateTimeWithTimeOfDay(
      dateTime: dayHandler.dateTime,
      timeOfDay: timeTableStartTime,
    );

    final dateEnd = tryParseDateTimeWithTimeOfDay(
      dateTime: dayHandler.dateTime,
      timeOfDay: timeTableEndTime,
    );

    var slotCount = 0;

    for (var i = -1; i < bookings.length; i++) {
      final isFirst = (i == -1);
      final isLast = (i == bookings.length - 1);

      var currentBookingDate =
          isFirst ? dateStart : bookings.elementAt(i).dateEnd;
      var nextBookingDate =
          isLast ? dateEnd : bookings.elementAt(i + 1).dateStart;

      final duration = nextBookingDate.difference(currentBookingDate);

      if (!isFirst) {
        final booking = bookings.elementAt(i);

        distributedBookings.add(
          SizedBox(
            width: double.infinity,
            child: booking.isDisabled
                ? DisabledBookingCard(
                    key: Key(booking.id),
                    cabin: cabin,
                    booking: booking,
                  )
                : BookingCard(
                    key: Key(booking.id),
                    cabin: cabin,
                    booking: booking,
                  ),
          ),
        );
      }

      final runningSlotList = <EmptyBookingSlot>[];

      if (duration > const Duration()) {
        var runningDuration = duration;

        while (runningDuration > maxSlotDuration) {
          final timeOfDay = TimeOfDay.fromDateTime(currentBookingDate);

          final duration = Duration(
            minutes: Duration.minutesPerHour - timeOfDay.minute,
          );

          nextBookingDate = currentBookingDate.add(duration);

          runningSlotList.add(
            EmptyBookingSlot(
              key: _emptyBookingSlotKey(
                currentBookingDate,
                slotCount++,
              ),
              cabin: cabin,
              dateStart: currentBookingDate,
              dateEnd: nextBookingDate,
            ),
          );

          currentBookingDate = nextBookingDate;

          runningDuration -= duration;
        }

        nextBookingDate = currentBookingDate.add(runningDuration);

        runningSlotList.add(
          EmptyBookingSlot(
            key: _emptyBookingSlotKey(
              currentBookingDate,
              slotCount++,
            ),
            cabin: cabin,
            dateStart: currentBookingDate,
            dateEnd: nextBookingDate,
          ),
        );

        distributedBookings.addAll(runningSlotList);
      }
    }

    return distributedBookings;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (final booking in _distributedBookings(context)) booking,
      ],
    );
  }
}
