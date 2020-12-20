import 'package:cabin_booking/constants.dart';
import 'package:cabin_booking/model/booking.dart';
import 'package:cabin_booking/model/cabin.dart';
import 'package:cabin_booking/model/day_handler.dart';
import 'package:cabin_booking/utils/date.dart';
import 'package:cabin_booking/widgets/booking/booking_card.dart';
import 'package:cabin_booking/widgets/booking/empty_booking_slot.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sticky_header/flutter_sticky_header.dart';
import 'package:provider/provider.dart';

class BookingsScrollView extends StatelessWidget {
  final Cabin cabin;
  final Widget cabinIcon;
  final List<Booking> bookings;

  const BookingsScrollView({
    this.cabin,
    this.cabinIcon,
    this.bookings = const <Booking>[],
  });

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

    for (var i = -1; i < bookings.length; i++) {
      final isFirst = i == -1;
      final isLast = i == bookings.length - 1;

      var currentBookingDate = isFirst ? dateStart : bookings[i].dateEnd;
      var nextBookingDate = isLast ? dateEnd : bookings[i + 1].dateStart;

      final duration = nextBookingDate.difference(currentBookingDate);

      if (!isFirst) {
        distributedBookings.add(
          SizedBox(
            width: double.infinity,
            child: BookingCard(
              cabin: cabin,
              booking: bookings[i],
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
    return CustomScrollView(
      key: Key('${cabin.number}'),
      slivers: [
        SliverStickyHeader(
          header: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: cabinIcon,
          ),
          sliver: SliverList(
            delegate: SliverChildListDelegate(
              [
                for (final booking in _distributedBookings(context)) booking,
              ],
            ),
          ),
        )
      ],
    );
  }
}
