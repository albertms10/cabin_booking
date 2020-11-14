import 'package:cabin_booking/model/booking.dart';
import 'package:cabin_booking/widgets/booking/booking_card.dart';
import 'package:cabin_booking/widgets/layout/empty_booking.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class BookingStack extends StatelessWidget {
  final List<Booking> bookings;

  BookingStack({this.bookings = const []});

  List<Widget> _spacedBookings({int start = 15, int end = 22}) {
    List<Widget> spacedBookings = [];

    if (bookings.length == 0) return spacedBookings;

    DateTime startDate = DateTime.parse(
        DateFormat('yyyy-MM-dd').format(bookings[0].dateStart) + ' $start:00');
    DateTime endDate = DateTime.parse(
        DateFormat('yyyy-MM-dd').format(bookings[0].dateEnd) + ' $end:00');

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

      if (difference > 0)
        spacedBookings.add(
          EmptyBooking(duration: difference),
        );
    }

    return spacedBookings;
  }

  @override
  Widget build(BuildContext context) {
    final spacedBookings = _spacedBookings();

    return Column(
      children: [
        if (bookings.length > 0)
          for (int i = 0; i < spacedBookings.length; i++) spacedBookings[i]
        else
          Container(),
      ],
    );
  }
}
