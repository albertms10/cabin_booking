import 'package:cabin_booking/constants.dart';
import 'package:cabin_booking/model/booking.dart';
import 'package:cabin_booking/model/cabin.dart';
import 'package:cabin_booking/model/day_handler.dart';
import 'package:cabin_booking/utils/date_time_extension.dart';
import 'package:cabin_booking/widgets/booking/booking_card.dart';
import 'package:cabin_booking/widgets/booking/empty_booking_slot.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BookingsStack extends StatelessWidget {
  final Cabin cabin;
  final Set<Booking> bookings;

  const BookingsStack({
    Key? key,
    required this.cabin,
    this.bookings = const <Booking>{},
  }) : super(key: key);

  Key _emptyBookingSlotKey(DateTime dateTime, int index) => Key(
        '${dateTime.toIso8601String().split('T').first}'
        '-$key'
        '-$index',
      );

  List<Widget> _distributedBookings(BuildContext context) {
    final distributedBookings = <Widget>[];

    final dayHandler = Provider.of<DayHandler>(context);

    final startDateTime = dayHandler.dateTime.addTimeOfDay(kTimeTableStartTime);
    final endDateTime = dayHandler.dateTime.addTimeOfDay(kTimeTableEndTime);

    var slotCount = 0;

    for (var i = -1; i < bookings.length; i++) {
      final isFirst = i == -1;
      final isLast = i == bookings.length - 1;

      var currentBookingDate =
          isFirst ? startDateTime : bookings.elementAt(i).endDateTime;
      var nextBookingDateTime =
          isLast ? endDateTime : bookings.elementAt(i + 1).startDateTime;

      final duration = nextBookingDateTime.difference(currentBookingDate);

      if (!isFirst) {
        final booking = bookings.elementAt(i);

        distributedBookings.add(
          SizedBox(
            width: double.infinity,
            child: BookingCard(
              key: Key(booking.id),
              cabin: cabin,
              booking: booking,
            ),
          ),
        );
      }

      final runSlotList = <EmptyBookingSlot>[];

      if (duration > Duration.zero) {
        var runDuration = duration;

        while (runDuration > kMaxSlotDuration) {
          final timeOfDay = TimeOfDay.fromDateTime(currentBookingDate);

          final duration = Duration(
            minutes: Duration.minutesPerHour - timeOfDay.minute,
          );

          nextBookingDateTime = currentBookingDate.add(duration);

          runSlotList.add(
            EmptyBookingSlot(
              key: _emptyBookingSlotKey(currentBookingDate, slotCount++),
              cabin: cabin,
              startDateTime: currentBookingDate,
              endDateTime: nextBookingDateTime,
            ),
          );

          currentBookingDate = nextBookingDateTime;

          runDuration -= duration;
        }

        nextBookingDateTime = currentBookingDate.add(runDuration);

        runSlotList.add(
          EmptyBookingSlot(
            key: _emptyBookingSlotKey(currentBookingDate, slotCount++),
            cabin: cabin,
            startDateTime: currentBookingDate,
            endDateTime: nextBookingDateTime,
          ),
        );

        distributedBookings.addAll(runSlotList);
      }
    }

    return distributedBookings;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: _distributedBookings(context),
    );
  }
}
