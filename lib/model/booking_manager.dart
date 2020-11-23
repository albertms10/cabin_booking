import 'package:cabin_booking/model/booking.dart';
import 'package:cabin_booking/model/recurring_booking.dart';
import 'package:cabin_booking/utils/time_of_day.dart';
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

  List<Booking> get generatedRecurringBookings {
    final generatedBookings = <Booking>[];

    for (RecurringBooking recurringBooking in recurringBookings)
      generatedBookings.addAll(recurringBooking.bookings);

    return generatedBookings;
  }

  List<Booking> get allBookings =>
      [...bookings, ...generatedRecurringBookings]..sort(_sortBookings);

  List<Booking> _recurringBookingsOn(DateTime dateTime) {
    final filteredBookings = <Booking>[];

    for (RecurringBooking recurringBooking in recurringBookings) {
      final _booking = recurringBooking.bookingOn(dateTime);

      if (_booking != null) filteredBookings.add(_booking);
    }

    return filteredBookings;
  }

  List<Booking> bookingsOn(DateTime dateTime) => [
        ...bookings.where((booking) => booking.isOn(dateTime)),
        ..._recurringBookingsOn(dateTime),
      ]..sort(_sortBookings);

  bool bookingsCollideWith(Booking booking) =>
      bookingsOn(booking.date)
          .where((_booking) =>
              (_booking.recurringBookingId == null ||
                  _booking.recurringBookingId != booking.recurringBookingId) &&
              _booking.id != booking.id)
          .firstWhere(
            (_booking) => _booking.collidesWith(booking),
            orElse: () => null,
          ) !=
      null;

  int occupiedMinutesDurationOn(DateTime dateTime) {
    int runningDuration = 0;

    for (Booking booking in bookingsOn(dateTime)) {
      runningDuration += booking.duration.inMinutes;
    }

    return runningDuration;
  }

  double occupiedRatioOn(
    DateTime dateTime, {
    @required TimeOfDay startTime,
    @required TimeOfDay endTime,
  }) {
    final startDate = tryParseDateTimeWithFormattedTimeOfDay(
      dateTime: dateTime,
      formattedTimeOfDay: formatTimeOfDay(startTime),
    );

    final endDate = tryParseDateTimeWithFormattedTimeOfDay(
      dateTime: dateTime,
      formattedTimeOfDay: formatTimeOfDay(endTime),
    );

    final maxViewMinutesDuration = endDate.difference(startDate).inMinutes;

    return occupiedMinutesDurationOn(dateTime) / maxViewMinutesDuration;
  }

  List<DateTime> datesWithBookings() {
    final dates = <DateTime>[];

    for (Booking booking in allBookings) {
      final hasDate = dates.firstWhere(
            (date) => isSameDay(date, booking.date),
            orElse: () => null,
          ) !=
          null;

      if (!hasDate) dates.add(booking.date);
    }

    return dates;
  }

  double evertimeOccupiedRatio({
    @required TimeOfDay startTime,
    @required TimeOfDay endTime,
  }) {
    double runningRatio = 0.0;
    int count = 0;

    for (DateTime dateTime in datesWithBookings()) {
      count++;

      final currentRatio =
          occupiedRatioOn(dateTime, startTime: startTime, endTime: endTime);

      runningRatio += (currentRatio - runningRatio) / count;
    }

    return runningRatio;
  }

  Booking getBookingFromId(String id) =>
      bookings.firstWhere((booking) => booking.id == id);

  Booking getRecurringBookingFromId(String id) => recurringBookings
      .firstWhere((recurringBooking) => recurringBooking.id == id)
        ..recurringBookingId = id;

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
