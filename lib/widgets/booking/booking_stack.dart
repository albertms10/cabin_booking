import 'package:cabin_booking/model/booking.dart';
import 'package:cabin_booking/widgets/booking/booking_card.dart';
import 'package:cabin_booking/widgets/booking/empty_booking.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class BookingStack extends StatelessWidget {
  final List<Booking> bookings;

  BookingStack({this.bookings = const []});

  List<Widget> _spacedBookings({int start = 15, int end = 22}) {
    final spacedBookings = <Widget>[];

    final startDate = DateTime.parse(
      DateFormat('yyyy-MM-dd').format(
            bookings.length > 0 ? bookings[0].dateStart : DateTime.now(),
          ) +
          ' $start:00',
    );

    final endDate = DateTime.parse(
      DateFormat('yyyy-MM-dd').format(
            bookings.length > 0 ? bookings[0].dateEnd : DateTime.now(),
          ) +
          ' $end:00',
    );

    for (int i = -1; i < bookings.length; i++) {
      DateTime currentBookingDate = i >= 0 ? bookings[i].dateEnd : startDate;
      DateTime nextBookingDate =
          i < bookings.length - 1 ? bookings[i + 1].dateStart : endDate;

      int difference = nextBookingDate.difference(currentBookingDate).inMinutes;

      if (i >= 0)
        spacedBookings.add(
          SizedBox(
            width: double.infinity,
            child: BookingCard(booking: bookings[i]),
          ),
        );

      if (difference > 0) {
        final maxDuration = 60;

        int currentDifference = difference;

        while (currentDifference > maxDuration) {
          spacedBookings.add(
            EmptyBooking(duration: maxDuration),
          );

          currentDifference -= maxDuration;
        }

        spacedBookings.add(
          EmptyBooking(duration: currentDifference),
        );
      }
    }

    return spacedBookings;
  }

  @override
  Widget build(BuildContext context) {
    final spacedBookings = _spacedBookings();

    return Column(
      children: [
        for (int i = 0; i < spacedBookings.length; i++) spacedBookings[i]
      ],
    );
  }
}
