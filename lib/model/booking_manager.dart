import 'dart:collection';

import 'package:cabin_booking/model/booking.dart';
import 'package:cabin_booking/model/recurring_booking.dart';
import 'package:cabin_booking/utils/date.dart';
import 'package:flutter/material.dart';

class BookingManager with ChangeNotifier {
  Set<Booking> bookings;
  Set<RecurringBooking> recurringBookings;

  BookingManager({this.bookings, this.recurringBookings}) {
    bookings ??= SplayTreeSet();
    recurringBookings ??= SplayTreeSet();
  }

  BookingManager.from({
    List<dynamic> bookings,
    List<dynamic> recurringBookings,
  })  : bookings = SplayTreeSet.from(
          bookings.map((booking) => Booking.from(booking)),
        ),
        recurringBookings = SplayTreeSet.from(
          recurringBookings.map(
            (recurringBooking) => RecurringBooking.from(recurringBooking),
          ),
        );

  List<Map<String, dynamic>> bookingsToMapList() =>
      bookings.map((booking) => booking.toMap()).toList();

  List<Map<String, dynamic>> recurringBookingsToMapList() => recurringBookings
      .map((recurringBooking) => recurringBooking.toMap())
      .toList();

  List<Booking> get generatedBookingsFromRecurring {
    final generatedBookings = <Booking>[];

    for (final recurringBooking in recurringBookings) {
      generatedBookings.addAll(recurringBooking.bookings);
    }

    return generatedBookings;
  }

  Set<Booking> get allBookings => SplayTreeSet.from({
        ...bookings,
        ...generatedBookingsFromRecurring,
      });

  Set<Booking> _recurringBookingsOn(DateTime dateTime) {
    final filteredBookings = SplayTreeSet<Booking>();

    for (final recurringBooking in recurringBookings) {
      final booking = recurringBooking.bookingOn(dateTime);

      if (booking != null) filteredBookings.add(booking);
    }

    return filteredBookings;
  }

  Set<Booking> bookingsOn(DateTime dateTime) => SplayTreeSet.from({
        ...bookings.where((booking) => booking.isOn(dateTime)),
        ..._recurringBookingsOn(dateTime),
      });

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

  Duration _occupiedDuration([DateTime dateTime]) {
    var runningDuration = const Duration();

    for (final booking
        in dateTime != null ? bookingsOn(dateTime) : allBookings) {
      runningDuration += booking.duration;
    }

    return runningDuration;
  }

  Duration get accumulatedDuration => _occupiedDuration();

  double occupiedRatioOn(
    DateTime dateTime, {
    @required TimeOfDay startTime,
    @required TimeOfDay endTime,
  }) {
    final startDate = tryParseDateTimeWithTimeOfDay(
      dateTime: dateTime,
      timeOfDay: startTime,
    );

    final endDate = tryParseDateTimeWithTimeOfDay(
      dateTime: dateTime,
      timeOfDay: endTime,
    );

    final maxViewDuration = endDate.difference(startDate);

    return _occupiedDuration(dateTime).inMicroseconds /
        maxViewDuration.inMicroseconds;
  }

  double occupiedRatio({
    @required TimeOfDay startTime,
    @required TimeOfDay endTime,
    Set<DateTime> dates,
  }) {
    var runningRatio = 0.0;
    var count = 0;

    for (final dateTime in dates ?? datesWithBookings) {
      count++;

      final currentRatio = occupiedRatioOn(
        dateTime,
        startTime: startTime,
        endTime: endTime,
      );

      runningRatio += (currentRatio - runningRatio) / count;
    }

    return runningRatio;
  }

  Set<DateTime> get datesWithBookings {
    final dates = SplayTreeSet<DateTime>();

    for (final booking in allBookings) {
      final shouldAddDate = dates.firstWhere(
            (date) => isSameDay(date, booking.date),
            orElse: () => null,
          ) !=
          null;

      if (!shouldAddDate) dates.add(booking.date);
    }

    return dates;
  }

  Map<DateTime, int> get allBookingsCountPerDay {
    final bookingsPerDay = SplayTreeMap<DateTime, int>();

    for (final booking in allBookings) {
      if (bookingsPerDay.containsKey(booking.date)) {
        bookingsPerDay[booking.date] += 1;
      } else {
        bookingsPerDay[booking.date] = 1;
      }
    }

    return bookingsPerDay;
  }

  Map<TimeOfDay, Duration> get accumulatedTimeRangesOccupancy {
    final timeRanges = <TimeOfDay, Duration>{};

    for (final booking in allBookings) {
      for (final bookingTimeRange in booking.hoursSpan.entries) {
        if (timeRanges.containsKey(bookingTimeRange.key)) {
          timeRanges[bookingTimeRange.key] += bookingTimeRange.value;
        } else {
          timeRanges[bookingTimeRange.key] = bookingTimeRange.value;
        }
      }
    }

    return timeRanges;
  }

  Set<TimeOfDay> get mostOccupiedTimeRange {
    final sortedTimeRanges = SplayTreeSet<MapEntry<TimeOfDay, Duration>>.from(
      accumulatedTimeRangesOccupancy.entries,
      (a, b) => (b.value - a.value).inMicroseconds,
    );

    if (sortedTimeRanges.isEmpty) return {};

    final highestOccupancyDuration = sortedTimeRanges.first.value;

    return SplayTreeSet.from(
      sortedTimeRanges
          .where((timeRange) => timeRange.value == highestOccupancyDuration)
          .map((timeRange) => timeRange.key),
      (a, b) => (a.hour - b.hour) * 100 + a.minute - b.minute,
    );
  }

  Booking bookingFromId(String id) =>
      bookings.firstWhere((booking) => booking.id == id);

  RecurringBooking recurringBookingFromId(String id) => recurringBookings
      .firstWhere((recurringBooking) => recurringBooking.id == id)
        ..recurringBookingId = id;

  void addBooking(
    Booking booking, {
    bool notify = true,
  }) {
    bookings.add(booking);

    if (notify) notifyListeners();
  }

  void addRecurringBooking(
    RecurringBooking recurringBooking, {
    bool notify = true,
  }) {
    recurringBookings.add(recurringBooking);

    if (notify) notifyListeners();
  }

  void modifyBooking(
    Booking booking, {
    bool notify = true,
  }) {
    bookings
        .firstWhere((_booking) => booking.id == _booking.id)
        .replaceWith(booking);

    if (notify) notifyListeners();
  }

  void modifyRecurringBooking(
    RecurringBooking recurringBooking, {
    bool notify = true,
  }) {
    recurringBookings
        .firstWhere(
          (_recurringBooking) =>
              recurringBooking.recurringBookingId == _recurringBooking.id ||
              recurringBooking.id == _recurringBooking.id,
        )
        .replaceWith(recurringBooking);

    if (notify) notifyListeners();
  }

  void removeBookingById(
    String id, {
    bool notify = true,
  }) {
    bookings.removeWhere((booking) => booking.id == id);

    if (notify) notifyListeners();
  }

  void removeRecurringBookingById(
    String id, {
    bool notify = true,
  }) {
    recurringBookings
        .removeWhere((_recurringBooking) => _recurringBooking.id == id);

    if (notify) notifyListeners();
  }

  void emptyAllBookings({bool notify = true}) {
    bookings.clear();
    recurringBookings.clear();

    if (notify) notifyListeners();
  }
}
