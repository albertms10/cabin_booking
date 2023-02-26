import 'dart:collection' show SplayTreeMap, SplayTreeSet;

import 'package:cabin_booking/utils/date_time_extension.dart';
import 'package:cabin_booking/utils/string_extension.dart';
import 'package:cabin_booking/utils/time_of_day_extension.dart';
import 'package:collection/collection.dart' show IterableExtension, SetEquality;
import 'package:flutter/material.dart';

import 'booking/booking.dart';
import 'booking/recurring_booking.dart';
import 'booking/single_booking.dart';
import 'date/date_range.dart';
import 'date/date_ranger.dart';
import 'serializable.dart';

abstract class _JsonFields {
  static const bookings = 'b';
  static const recurringBookings = 'rb';
}

class BookingCollection with ChangeNotifier implements Serializable {
  late Set<SingleBooking> bookings;
  late Set<RecurringBooking> recurringBookings;

  BookingCollection({
    Set<SingleBooking>? bookings,
    Set<RecurringBooking>? recurringBookings,
  })  : bookings = bookings ?? SplayTreeSet(),
        recurringBookings = recurringBookings ?? SplayTreeSet();

  BookingCollection.fromJson(Map<String, dynamic> other)
      : bookings = SplayTreeSet.of(
          (other[_JsonFields.bookings] as List<dynamic>)
              .cast<Map<String, dynamic>>()
              .map<SingleBooking>(SingleBooking.fromJson),
        ),
        recurringBookings = SplayTreeSet.of(
          (other[_JsonFields.recurringBookings] as List<dynamic>)
              .cast<Map<String, dynamic>>()
              .map<RecurringBooking>(RecurringBooking.fromJson),
        );

  @override
  Map<String, dynamic> toJson() => {
        _JsonFields.bookings:
            bookings.map((booking) => booking.toJson()).toList(),
        _JsonFields.recurringBookings: recurringBookings
            .map((recurringBooking) => recurringBooking.toJson())
            .toList(),
      };

  List<SingleBooking> get singleBookingsFromRecurring => [
        for (final recurringBooking in recurringBookings)
          ...recurringBooking.bookings,
      ];

  Set<SingleBooking> get allBookings => SplayTreeSet.of({
        ...bookings,
        ...singleBookingsFromRecurring,
      });

  Set<SingleBooking> singleBookingsBetween(DateRanger dateRanger) =>
      SplayTreeSet.of(
        bookings.where((booking) => booking.overlapsWith(dateRanger)),
      );

  Set<SingleBooking> recurringBookingsBetween(DateRanger dateRanger) =>
      SplayTreeSet.of(
        singleBookingsFromRecurring.where(
          (recurringBooking) => recurringBooking.overlapsWith(dateRanger),
        ),
      );

  Set<SingleBooking> allBookingsBetween(DateRanger dateRanger) =>
      SplayTreeSet.of({
        ...singleBookingsBetween(dateRanger),
        ...recurringBookingsBetween(dateRanger),
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

  bool bookingsOverlapWith(Booking booking) {
    if (booking.dateOnly == null) return false;

    return allBookingsOn(booking.dateOnly!)
            .where(
              (comparingBooking) =>
                  (comparingBooking.recurringBooking?.id == null ||
                      comparingBooking.recurringBooking?.id !=
                          booking.recurringBooking?.id) &&
                  comparingBooking.id != booking.id,
            )
            .firstWhereOrNull(
              (comparingBooking) => comparingBooking.overlapsWith(booking),
            ) !=
        null;
  }

  Duration occupiedDuration([DateRanger dateRanger = DateRange.infinite]) {
    var runDuration = Duration.zero;
    for (final booking in allBookings) {
      runDuration += booking.overlappingDurationWith(dateRanger);
    }

    return runDuration;
  }

  double occupancyPercentOn([DateRanger? dateRanger]) {
    dateRanger ??= DateRange.today();

    return occupiedDuration(dateRanger).inMicroseconds /
        dateRanger.duration.inMicroseconds;
  }

  Set<DateTime> datesWithBookings([DateRanger? dateRanger]) {
    final dates = SplayTreeSet<DateTime>();
    final bookingsList =
        dateRanger != null ? allBookingsBetween(dateRanger) : allBookings;

    for (final booking in bookingsList) {
      final shouldAddDate = dates.firstWhereOrNull(
            (date) =>
                booking.dateOnly != null &&
                date.isSameDateAs(booking.dateOnly!),
          ) !=
          null;

      if (!shouldAddDate) dates.add(booking.dateOnly!);
    }

    return dates;
  }

  Map<DateTime, int> get allBookingsCountPerDay {
    final bookingsPerDay = SplayTreeMap<DateTime, int>();
    for (final booking in allBookings) {
      bookingsPerDay.update(
        booking.dateOnly!,
        (count) => count + 1,
        ifAbsent: () => 1,
      );
    }

    return bookingsPerDay;
  }

  Map<DateTime, Duration> occupiedDurationPerWeek([DateRanger? dateRanger]) {
    final bookingsPerDay = SplayTreeMap<DateTime, Duration>();
    for (final booking in allBookings) {
      if (dateRanger != null && !dateRanger.includes(booking.dateOnly!)) {
        continue;
      }

      bookingsPerDay.update(
        booking.dateOnly!.firstDayOfWeek,
        (duration) => duration + booking.duration,
        ifAbsent: () => booking.duration,
      );
    }

    return bookingsPerDay;
  }

  Map<TimeOfDay, Duration> accumulatedTimeRangesOccupancy([
    DateRanger? dateRanger,
  ]) {
    final timeRanges =
        SplayTreeMap<TimeOfDay, Duration>(TimeOfDayExtension.compare);

    final bookingsSet =
        dateRanger != null ? allBookingsBetween(dateRanger) : allBookings;
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

  Set<TimeOfDay> mostOccupiedTimeRange([DateRanger? dateRanger]) =>
      mostOccupiedTimeRangeFromAccumulated(
        accumulatedTimeRangesOccupancy(dateRanger),
      );

  SingleBooking singleBookingFromId(String id) =>
      bookings.firstWhere((booking) => booking.id == id);

  List<Booking> searchBookings(String query, {int? limit}) {
    final results = <Booking>[];
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
    singleBookingFromId(booking.id).replaceWith(booking);

    if (notify) notifyListeners();
  }

  void modifyRecurringBooking(
    RecurringBooking recurringBooking, {
    bool notify = true,
  }) {
    recurringBookings
        .firstWhere(
          (comparingRecurringBooking) =>
              recurringBooking.recurringBooking.id ==
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
    recurringBookings
        .removeWhere((recurringBooking) => recurringBooking.id == id);

    if (notify) notifyListeners();
  }

  void emptyAllBookings({bool notify = true}) {
    bookings.clear();
    recurringBookings.clear();

    if (notify) notifyListeners();
  }

  @override
  String toString() => '$bookings\n$recurringBookings';

  @override
  bool operator ==(Object other) =>
      other is BookingCollection &&
      const SetEquality<SingleBooking>().equals(bookings, other.bookings) &&
      const SetEquality<RecurringBooking>()
          .equals(recurringBookings, other.recurringBookings);

  @override
  int get hashCode => Object.hash(
        Object.hashAllUnordered(bookings),
        Object.hashAllUnordered(recurringBookings),
      );
}
