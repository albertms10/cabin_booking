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

  List<Booking> recurringBookingsOn(DateTime dateTime) {
    final filteredBookings = <Booking>[];

    recurringBookings.forEach((recurringBooking) {
      final _booking = recurringBooking.bookingOn(dateTime);

      if (_booking != null) filteredBookings.add(_booking);
    });

    return filteredBookings;
  }

  List<Booking> bookingsOn(DateTime dateTime) => [
        ...bookings.where((booking) => booking.isOn(dateTime)),
        ...recurringBookingsOn(dateTime),
      ]..sort(_sortBookings);

  bool bookingsCollideWith(Booking booking) =>
      bookingsOn(booking.dateEnd)
          .where((_booking) => _booking.id != booking.id)
          .firstWhere(
            (_booking) => _booking.collidesWith(booking),
            orElse: () => null,
          ) !=
      null;

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
          (_recurringBooking) =>
              recurringBooking.recurringBookingId == _recurringBooking.id,
        )
        .replaceRecurringWith(recurringBooking);

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
