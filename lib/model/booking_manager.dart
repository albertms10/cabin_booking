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

  BookingManager.from({
    List<dynamic> bookings,
    List<dynamic> recurringBookings,
  })  : bookings = bookings.map((booking) => Booking.from(booking)).toList(),
        recurringBookings = recurringBookings
            .map((recurringBooking) => RecurringBooking.from(recurringBooking))
            .toList();

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
    booking.id = Uuid().v4();

    bookings
      ..add(booking)
      ..sort(_sortBookings);

    notifyListeners();
  }

  void addRecurringBooking(RecurringBooking recurringBooking) {
    recurringBooking.id = Uuid().v4();

    recurringBookings
      ..add(recurringBooking)
      ..sort(_sortBookings);

    notifyListeners();
  }

  void modifyBooking(Booking booking) {
    bookings
        .firstWhere((_booking) => booking.id == _booking.id)
        .replaceWith(booking);

    bookings.sort(_sortBookings);

    notifyListeners();
  }

  void modifyRecurringBooking(RecurringBooking recurringBooking) {
    recurringBookings
        .firstWhere(
            (_recurringBooking) => recurringBooking.id == _recurringBooking.id)
        .replaceWith(recurringBooking);

    recurringBookings.sort(_sortBookings);

    notifyListeners();
  }

  void removeBookingById(String id) {
    bookings.removeWhere((booking) => booking.id == id);

    notifyListeners();
  }

  void removeRecurringBookingById(String id) {
    recurringBookings
        .removeWhere((_recurringBooking) => _recurringBooking.id == id);

    notifyListeners();
  }
}
