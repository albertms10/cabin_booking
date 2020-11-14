import 'package:cabin_booking/model/booking.dart';
import 'package:flutter/material.dart';

class BookingCard extends StatelessWidget {
  final Booking booking;

  BookingCard({@required this.booking});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(8),
      child: InkWell(
        onTap: () => {},
        child: Container(
          height: booking.duration.inMinutes * 1.7,
          padding: EdgeInsets.all(8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(booking.studentName),
              Text(
                booking.dateRange,
                style: TextStyle(color: Colors.black38),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
