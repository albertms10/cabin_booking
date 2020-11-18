import 'package:cabin_booking/model/booking.dart';
import 'package:cabin_booking/model/recurring_booking.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

int _sortBookings(Booking a, Booking b) => a.dateStart.compareTo(b.dateStart);

class BookingManager with ChangeNotifier {
  List<Booking> bookings;
  List<RecurringBooking> recurringBookings;

  BookingManager({this.bookings, this.recurringBookings}) {
    if (bookings == null) bookings = <Booking>[];
    if (recurringBookings == null) recurringBookings = <RecurringBooking>[];
  }

  BookingManager.from(List<dynamic> other)
      : bookings = other.map((item) => Booking.from(item)).toList();

  List<Map<String, dynamic>> bookingsToMapList() =>
      bookings.map((booking) => booking.toMap()).toList();

  List<Map<String, dynamic>> recurringBookingsToMapList() => recurringBookings
      .map((recurringBooking) => recurringBooking.toMap())
      .toList();

  List<Booking> bookingsOn(DateTime dateTime) => [
        ...bookings.where((booking) => booking.isOn(dateTime)),
        ...recurringBookings.where(
            (recurringBooking) => recurringBooking.hasBookingOn(dateTime))
      ]..sort(_sortBookings);

  void addBooking(Booking booking) {
    booking.id = Uuid().v1();

    bookings.add(booking);

    bookings.sort(_sortBookings);

    notifyListeners();
  }

  void modifyBooking(Booking _booking) {
    bookings
        .firstWhere((booking) => _booking.id == booking.id)
        .replaceWith(_booking);

    bookings.sort(_sortBookings);

    notifyListeners();
  }

  void removeBookingById(String id) {
    bookings.removeWhere((booking) => booking.id == id);
    notifyListeners();
  }
}
