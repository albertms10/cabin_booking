import 'dart:convert';

import 'package:cabin_booking/model/booking.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class BookingManager with ChangeNotifier {
  List<Booking> bookings;

  BookingManager({this.bookings}) {
    if (bookings == null) bookings = List<Booking>();
  }

  BookingManager.from(List<dynamic> other)
      : bookings = other.map((item) => Booking.from(item)).toList();

  List<Booking> parseBookings(String jsonString) => json
      .decode(jsonString)
      .map<Booking>((json) => Booking.from(json))
      .toList();

  List<Map<String, dynamic>> bookingsToMapList() =>
      bookings.map((booking) => booking.toMap()).toList();

  List<Booking> bookingsOn(DateTime dateTime) => bookings
      .where(
        (booking) =>
            booking.dateStart.year == dateTime.year &&
            booking.dateStart.month == dateTime.month &&
            booking.dateStart.day == dateTime.day,
      )
      .toList();

  void addBooking(Booking booking) {
    booking.id = Uuid().v1();

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
