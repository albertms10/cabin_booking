import 'package:cabin_booking/model/booking.dart';
import 'package:flutter/material.dart';

class BookingManager with ChangeNotifier {
  int cabinNumber;
  final List<Booking> bookings;

  BookingManager({this.cabinNumber, @required this.bookings});

  List<Booking> bookingsOn(DateTime dateTime) => bookings
      .where(
        (booking) =>
            booking.dateStart.year == dateTime.year &&
            booking.dateStart.month == dateTime.month &&
            booking.dateStart.day == dateTime.day,
      )
      .toList();

  void addBooking(Booking booking) {
    bookings.add(booking);
    notifyListeners();
  }

  void removeBookingById(String id) {
    bookings.removeWhere((booking) => booking.id == id);
    notifyListeners();
  }
}
