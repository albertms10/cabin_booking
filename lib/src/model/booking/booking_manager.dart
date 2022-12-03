import 'dart:collection' show SplayTreeMap, SplayTreeSet;

import 'package:cabin_booking/utils/date_time_extension.dart';
import 'package:cabin_booking/utils/string_extension.dart';
import 'package:cabin_booking/utils/time_of_day_extension.dart';
import 'package:collection/collection.dart' show IterableExtension;
import 'package:flutter/material.dart';

import '../date/date_range.dart';
import 'booking.dart';
import 'recurring_booking.dart';
import 'single_booking.dart';

class BookingManager with ChangeNotifier {
  late Set<SingleBooking> bookings;
  late Set<RecurringBooking> recurringBookings;

  BookingManager({
    Set<SingleBooking>? bookings,
    Set<RecurringBooking>? recurringBookings,
  }) {
    this.bookings = bookings ?? SplayTreeSet();
    this.recurringBookings = recurringBookings ?? SplayTreeSet();
  }

  BookingManager.from({
    required List<dynamic> bookings,
    required List<dynamic> recurringBookings,
  })  : bookings = SplayTreeSet.of(
          bookings
              .cast<Map<String, dynamic>>()
              .map<SingleBooking>(SingleBooking.from),
        ),
        recurringBookings = SplayTreeSet.of(
          recurringBookings
              .cast<Map<String, dynamic>>()
              .map<RecurringBooking>(RecurringBooking.from),
        );

  List<Map<String, dynamic>> singleBookingsToJson() =>
      bookings.map((booking) => booking.toJson()).toList();

  List<Map<String, dynamic>> recurringBookingsToJson() => recurringBookings
      .map((recurringBooking) => recurringBooking.toJson())
      .toList();

  List<SingleBooking> get singleBookingsFromRecurring => [
        for (final recurringBooking in recurringBookings)
          ...recurringBooking.bookings,
      ];

  Set<SingleBooking> get allBookings => SplayTreeSet.of({
        ...bookings,
        ...singleBookingsFromRecurring,
      });

  Set<SingleBooking> singleBookingsBetween(DateRanger dateRange) =>
      SplayTreeSet.of(
        bookings.where((booking) => booking.isBetween(dateRange)),
      );

  Set<SingleBooking> recurringBookingsBetween(DateRanger dateRange) =>
      SplayTreeSet.of(
        singleBookingsFromRecurring.where(
          (recurringBooking) => recurringBooking.isBetween(dateRange),
        ),
      );

  Set<SingleBooking> allBookingsBetween(DateRanger dateRange) =>
      SplayTreeSet.of({
        ...singleBookingsBetween(dateRange),
        ...recurringBookingsBetween(dateRange),
      });

  Set<SingleBooking> singleBookingsOn(DateTime dateTime) => SplayTreeSet.of(
        bookings.where((booking) => booking.isOn(dateTime)),
      );

  Set<SingleBooking> recurringBookingsOn(DateTime dateTime) {
    final filteredBookings = SplayTreeSet<SingleBooking>();

    for (final recurringBooking in recurringBookings) {
      final booking = recurringBooking.bookingOn(dateTime);

      if (booking != null) filteredBookings.add(booking);
    }

    return filteredBookings;
  }

  Set<SingleBooking> allBookingsOn(DateTime dateTime) => SplayTreeSet.of({
        ...singleBookingsOn(dateTime),
        ...recurringBookingsOn(dateTime),
      });

  bool bookingsCollideWith(Booking booking) {
    if (booking.date == null) return false;

    return allBookingsOn(booking.date!)
            .where(
              (comparingBooking) =>
                  (comparingBooking.recurringBookingId == null ||
                      comparingBooking.recurringBookingId !=
                          booking.recurringBookingId) &&
                  comparingBooking.id != booking.id,
            )
            .firstWhereOrNull(
              (comparingBooking) => comparingBooking.collidesWith(booking),
            ) !=
        null;
  }

  Duration occupiedDuration({DateTime? dateTime, DateRanger? dateRange}) {
    if (dateTime != null && dateRange != null) {
      throw ArgumentError(
        'Either dateTime or dateRange must be given, but not both.',
      );
    }

    var runDuration = Duration.zero;

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
    final fallbackDateTime = dateTime ?? DateTime.now();
    final startDate = fallbackDateTime.addTimeOfDay(startTime);
    final endDate = fallbackDateTime.addTimeOfDay(endTime);

    final maxViewDuration = endDate.difference(startDate);

    return occupiedDuration(dateTime: fallbackDateTime).inMicroseconds /
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

  Set<DateTime> datesWithBookings([DateRanger? dateRange]) {
    final dates = SplayTreeSet<DateTime>();

    final bookingsList =
        dateRange != null ? allBookingsBetween(dateRange) : allBookings;

    for (final booking in bookingsList) {
      final shouldAddDate = dates.firstWhereOrNull(
            (date) => booking.date != null && date.isSameDateAs(booking.date!),
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

  Map<DateTime, Duration> occupiedDurationPerWeek([DateRanger? dateRange]) {
    final bookingsPerDay = SplayTreeMap<DateTime, Duration>();

    for (final booking in allBookings) {
      if (dateRange != null && !dateRange.includes(booking.date!)) continue;

      bookingsPerDay.update(
        booking.date!.firstDayOfWeek,
        (duration) => duration + booking.duration,
        ifAbsent: () => booking.duration,
      );
    }

    return bookingsPerDay;
  }

  Map<TimeOfDay, Duration> accumulatedTimeRangesOccupancy([
    DateRanger? dateRange,
  ]) {
    final timeRanges =
        SplayTreeMap<TimeOfDay, Duration>(TimeOfDayExtension.compare);

    final bookingsSet =
        dateRange != null ? allBookingsBetween(dateRange) : allBookings;

    for (final booking in bookingsSet) {
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

  static Set<TimeOfDay> mostOccupiedTimeRangeFromAccumulated(
    Map<TimeOfDay, Duration> accumulatedTimeRangesOccupancy,
  ) {
    if (accumulatedTimeRangesOccupancy.isEmpty) return SplayTreeSet();

    final timeRangesSortedByDuration =
        SplayTreeSet<MapEntry<TimeOfDay, Duration>>.of(
      accumulatedTimeRangesOccupancy.entries,
      (a, b) => a.value.compareTo(b.value),
    );

    final highestOccupancyDuration = timeRangesSortedByDuration.first.value;

    return SplayTreeSet.of(
      timeRangesSortedByDuration
          .where((timeRange) => timeRange.value == highestOccupancyDuration)
          .map<TimeOfDay>((timeRange) => timeRange.key),
      TimeOfDayExtension.compare,
    );
  }

  Set<TimeOfDay> mostOccupiedTimeRange([DateRanger? dateRange]) =>
      mostOccupiedTimeRangeFromAccumulated(
        accumulatedTimeRangesOccupancy(dateRange),
      );

  SingleBooking singleBookingFromId(String id) =>
      bookings.firstWhere((booking) => booking.id == id);

  RecurringBooking recurringBookingFromId(String? id) => recurringBookings
      .firstWhere((recurringBooking) => recurringBooking.id == id)
    ..recurringBookingId = id;

  Set<Booking> searchBookings(String query, {int? limit}) {
    final results = <Booking>{};
    for (final booking in allBookings) {
      if (query.matchesWith([booking.description])) {
        results.add(booking);
      }
      if (limit != null && results.length >= limit) return results;
    }

    return results;
  }

  void addSingleBooking(
    SingleBooking booking, {
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

  void modifySingleBooking(
    SingleBooking booking, {
    bool notify = true,
  }) {
    bookings
        .firstWhere((comparingBooking) => comparingBooking.id == booking.id)
        .replaceWith(booking);

    if (notify) notifyListeners();
  }

  void modifyRecurringBooking(
    RecurringBooking recurringBooking, {
    bool notify = true,
  }) {
    recurringBookings
        .firstWhere(
          (comparingRecurringBooking) =>
              recurringBooking.recurringBookingId ==
                  comparingRecurringBooking.id ||
              recurringBooking.id == comparingRecurringBooking.id,
        )
        .replaceWith(recurringBooking);

    if (notify) notifyListeners();
  }

  void removeSingleBookingById(
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
    recurringBookings.removeWhere(
      (comparingRecurringBooking) => comparingRecurringBooking.id == id,
    );

    if (notify) notifyListeners();
  }

  void emptyAllBookings({bool notify = true}) {
    bookings.clear();
    recurringBookings.clear();

    if (notify) notifyListeners();
  }
}
