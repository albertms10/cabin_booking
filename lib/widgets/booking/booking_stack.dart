import 'package:cabin_booking/model/booking.dart';
import 'package:cabin_booking/widgets/booking/booking_card.dart';
import 'package:flutter/material.dart';

class BookingStack extends StatelessWidget {
  final List<Booking> bookings;

  BookingStack({this.bookings = const []});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        if (bookings.length > 0)
          for (int booking = 0; booking < bookings.length; booking++)
            SizedBox(
              width: double.infinity,
              child: BookingCard(booking: bookings[booking]),
            )
        else
          Container(),
      ],
    );
  }
}
