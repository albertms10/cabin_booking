import 'package:cabin_booking/model/booking.dart';
import 'package:cabin_booking/model/cabin.dart';
import 'package:cabin_booking/model/day_handler.dart';
import 'package:cabin_booking/widgets/booking/booking_card.dart';
import 'package:cabin_booking/widgets/booking/empty_booking.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class BookingsStack extends StatelessWidget {
  final Cabin cabin;
  final List<Booking> bookings;

  BookingsStack({this.cabin, this.bookings = const []});

  List<Widget> _distributedBookings(context, {int start = 15, int end = 22}) {
    final distributedBookings = <Widget>[];

    DayHandler _dayHandler = Provider.of<DayHandler>(context);

    final startDate = DateTime.parse(
      DateFormat('yyyy-MM-dd').format(_dayHandler.dateTime) + ' $start:00',
    );

    final endDate = DateTime.parse(
      DateFormat('yyyy-MM-dd').format(_dayHandler.dateTime) + ' $end:00',
    );

    for (int i = -1; i < bookings.length; i++) {
      DateTime currentBookingDate = i >= 0 ? bookings[i].dateEnd : startDate;
      DateTime nextBookingDate =
          i < bookings.length - 1 ? bookings[i + 1].dateStart : endDate;

      int difference = nextBookingDate.difference(currentBookingDate).inMinutes;

      if (i >= 0)
        distributedBookings.add(
          SizedBox(
            width: double.infinity,
            child: BookingCard(booking: bookings[i]),
          ),
        );

      if (difference > 0) {
        final maxDuration = 60;

        int currentDifference = difference;

        while (currentDifference > maxDuration) {
          nextBookingDate =
              currentBookingDate.add(Duration(minutes: maxDuration));

          distributedBookings.add(
            EmptyBooking(
              cabin: cabin,
              startDate: currentBookingDate,
              endDate: nextBookingDate,
              duration: maxDuration,
            ),
          );

          currentBookingDate =
              currentBookingDate.add(Duration(minutes: maxDuration));

          currentDifference -= maxDuration;
        }

        nextBookingDate =
            currentBookingDate.add(Duration(minutes: currentDifference));

        distributedBookings.add(
          EmptyBooking(
            cabin: cabin,
            startDate: currentBookingDate,
            endDate: nextBookingDate,
            duration: currentDifference,
          ),
        );
      }
    }

    return distributedBookings;
  }

  @override
  Widget build(BuildContext context) {
    final distributedBookings = _distributedBookings(context);

    return Column(
      children: [
        for (int i = 0; i < distributedBookings.length; i++)
          distributedBookings[i]
      ],
    );
  }
}
