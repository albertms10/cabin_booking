import 'dart:collection';

import 'package:cabin_booking/model/booking.dart';
import 'package:cabin_booking/model/date_range.dart';
import 'package:cabin_booking/model/recurring_booking.dart';
import 'package:cabin_booking/utils/datetime.dart';
import 'package:collection/collection.dart' show IterableExtension;
import 'package:flutter/material.dart';

class BookingManager with ChangeNotifier {
  late Set<Booking> bookings;
  late Set<RecurringBooking> recurringBookings;

  BookingManager({
    Set<Booking>? bookings,
    Set<RecurringBooking>? recurringBookings,
  }) {
    this.bookings = bookings ?? SplayTreeSet();
    this.recurringBookings = recurringBookings ?? SplayTreeSet();
  }

  BookingManager.from({
    required List<dynamic> bookings,
    required List<dynamic> recurringBookings,
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

  List<Booking> get generatedBookingsFromRecurring => [
        for (final recurringBooking in recurringBookings)
          ...recurringBooking.bookings,
      ];

  Set<Booking> get allBookings => SplayTreeSet.from({
        ...bookings,
        ...generatedBookingsFromRecurring,
      });

  Set<Booking> bookingsBetween(DateRange dateRange) => SplayTreeSet.from(
        bookings.where((booking) => booking.isBetween(dateRange)),
      );

  Set<Booking> recurringBookingsBetween(DateRange dateRange) =>
      SplayTreeSet.from(
        generatedBookingsFromRecurring.where(
          (recurringBooking) => recurringBooking.isBetween(dateRange),
        ),
      );

  Set<Booking> allBookingsBetween(DateRange dateRange) => SplayTreeSet.from({
        ...bookingsBetween(dateRange),
        ...recurringBookingsBetween(dateRange),
      });

  Set<Booking> bookingsOn(DateTime dateTime) => SplayTreeSet.from(
        bookings.where((booking) => booking.isOn(dateTime)),
      );

  Set<Booking> recurringBookingsOn(DateTime dateTime) {
    final filteredBookings = SplayTreeSet<Booking>();

    for (final recurringBooking in recurringBookings) {
      final booking = recurringBooking.bookingOn(dateTime);

      if (booking != null) filteredBookings.add(booking);
    }

    return filteredBookings;
  }

  Set<Booking> allBookingsOn(DateTime dateTime) => SplayTreeSet.from({
        ...bookingsOn(dateTime),
        ...recurringBookingsOn(dateTime),
      });

  bool bookingsCollideWith(Booking booking) {
    if (booking.date == null) return false;

    return allBookingsOn(booking.date!)
            .where(
              (_booking) =>
                  (_booking.recurringBookingId == null ||
                      _booking.recurringBookingId !=
                          booking.recurringBookingId) &&
                  _booking.id != booking.id,
            )
            .firstWhereOrNull(
              (_booking) => _booking.collidesWith(booking),
            ) !=
        null;
  }

  Duration occupiedDuration({DateTime? dateTime, DateRange? dateRange}) {
    assert(!((dateTime != null) && (dateRange != null)));

    var runDuration = const Duration();

    final bookingsList = dateTime != null
        ? allBookingsOn(dateTime)
        : dateRange != null
            ? allBookingsBetween(dateRange)
            : allBookings;

    for (final booking in bookingsList) {
      runDuration += booking.duration;
    }

    return runDuration;
  }

  double occupancyPercentOn(
    DateTime? dateTime, {
    required TimeOfDay startTime,
    required TimeOfDay endTime,
  }) {
    final startDate = dateTimeWithTimeOfDay(
      dateTime: dateTime,
      timeOfDay: startTime,
    );

    final endDate = dateTimeWithTimeOfDay(
      dateTime: dateTime,
      timeOfDay: endTime,
    );

    final maxViewDuration = endDate.difference(startDate);

    return occupiedDuration(dateTime: dateTime).inMicroseconds /
        maxViewDuration.inMicroseconds;
  }

  double occupancyPercent({
    required TimeOfDay startTime,
    required TimeOfDay endTime,
    Set<DateTime>? dates,
  }) {
    var runPercent = 0.0;
    var count = 0;

    for (final dateTime in dates ?? datesWithBookings()) {
      count++;

      final currentPercent = occupancyPercentOn(
        dateTime,
        startTime: startTime,
        endTime: endTime,
      );

      runPercent += (currentPercent - runPercent) / count;
    }

    return runPercent;
  }

  Set<DateTime> datesWithBookings([DateRange? dateRange]) {
    final dates = SplayTreeSet<DateTime>();

    final bookingsList =
        dateRange != null ? allBookingsBetween(dateRange) : allBookings;

    for (final booking in bookingsList) {
      final shouldAddDate = dates.firstWhereOrNull(
            (date) => isSameDay(date, booking.date),
          ) !=
          null;

      if (!shouldAddDate) dates.add(booking.date!);
    }

    return dates;
  }

  Map<DateTime, int> get allBookingsCountPerDay {
    final bookingsPerDay = SplayTreeMap<DateTime, int>();

    for (final booking in allBookings) {
      bookingsPerDay.update(
        booking.date!,
        (count) => count + 1,
        ifAbsent: () => 1,
      );
    }

    return bookingsPerDay;
  }

  Map<DateTime, Duration> occupiedDurationPerWeek([DateRange? dateRange]) {
    final bookingsPerDay = SplayTreeMap<DateTime, Duration>();

    for (final booking in allBookings) {
      if (dateRange != null && !dateRange.includes(booking.date!)) continue;

      bookingsPerDay.update(
        firstWeekDate(booking.date!),
        (duration) => duration + booking.duration,
        ifAbsent: () => booking.duration,
      );
    }

    return bookingsPerDay;
  }

  Map<TimeOfDay, Duration> accumulatedTimeRangesOccupancy([
    DateRange? dateRange,
  ]) {
    final timeRanges = <TimeOfDay, Duration>{};

    final bookingsList =
        dateRange != null ? allBookingsBetween(dateRange) : allBookings;

    for (final booking in bookingsList) {
      for (final bookingTimeRange in booking.hoursSpan.entries) {
        timeRanges.update(
          bookingTimeRange.key,
          (duration) => duration + bookingTimeRange.value,
          ifAbsent: () => bookingTimeRange.value,
        );
      }
    }

    return timeRanges;
  }

  Set<TimeOfDay> mostOccupiedTimeRange([DateRange? dateRange]) {
    final sortedTimeRanges = SplayTreeSet<MapEntry<TimeOfDay, Duration>>.from(
      accumulatedTimeRangesOccupancy(dateRange).entries,
      (a, b) => (b.value - a.value).inMicroseconds,
    );

    if (sortedTimeRanges.isEmpty) return SplayTreeSet();

    final highestOccupancyDuration = sortedTimeRanges.first.value;

    return SplayTreeSet.from(
      sortedTimeRanges
          .where((timeRange) => timeRange.value == highestOccupancyDuration)
          .map((timeRange) => timeRange.key),
      compareTime,
    );
  }

  Booking bookingFromId(String id) =>
      bookings.firstWhere((booking) => booking.id == id);

  RecurringBooking recurringBookingFromId(String? id) => recurringBookings
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

  void modifyBookingStatusById(
    String? id,
    BookingStatus status, {
    bool notify = true,
  }) {
    bookings.firstWhere((booking) => booking.id == id).status = status;

    if (notify) notifyListeners();
  }

  void modifyRecurringBookingStatusById(
    String id,
    BookingStatus status, {
    bool notify = true,
  }) {
    recurringBookings
        .firstWhere((recurringBooking) => recurringBooking.id == id)
        .status = status;

    if (notify) notifyListeners();
  }

  void removeBookingById(
    String? id, {
    bool notify = true,
  }) {
    bookings.removeWhere((booking) => booking.id == id);

    if (notify) notifyListeners();
  }

  void removeRecurringBookingById(
    String? id, {
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
