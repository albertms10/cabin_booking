import 'package:cabin_booking/model/booking.dart';
import 'package:flutter/material.dart';

class BookingManager with ChangeNotifier {
  int cabinNumber;
  List<Booking> bookings;

  BookingManager({this.cabinNumber, this.bookings}) {
    if (bookings == null) bookings = List<Booking>();
  }

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

    // TODO: Remove when implementing Firestore
    bookings.sort((a, b) => a.dateStart.compareTo(b.dateStart));

    notifyListeners();
  }

  void modifyBooking(Booking booking) {
    bookings
        .firstWhere((_booking) => booking.id == _booking.id)
        .replaceWith(booking);

    // TODO: Remove when implementing Firestore
    bookings.sort((a, b) => a.dateStart.compareTo(b.dateStart));

    notifyListeners();
  }

  void removeBookingById(String id) {
    bookings.removeWhere((booking) => booking.id == id);
    notifyListeners();
  }
}
