import 'dart:collection';
import 'dart:convert' show json;

import 'package:cabin_booking/model/booking.dart';
import 'package:cabin_booking/model/cabin.dart';
import 'package:cabin_booking/model/date_range.dart';
import 'package:cabin_booking/model/recurring_booking.dart';
import 'package:cabin_booking/model/writable_manager.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

Iterable<Cabin> _parseCabins(String jsonString) =>
    (json.decode(jsonString) as List<dynamic>)
        .map<Cabin>((json) => Cabin.from(json));

class CabinManager extends WritableManager<Set<Cabin>> with ChangeNotifier {
  Set<Cabin> cabins;

  CabinManager({
    this.cabins,
    String fileName = 'cabin_manager',
  }) : super(fileName) {
    cabins ??= SplayTreeSet();
  }

  List<Map<String, dynamic>> cabinsToMapList() =>
      cabins.map((cabin) => cabin.toMap()).toList();

  Cabin cabinFromId(String id) => cabins.firstWhere((cabin) => cabin.id == id);

  int get lastCabinNumber => cabins.isEmpty ? 0 : cabins.last.number;

  Set<DateTime> allCabinsDatesWithBookings([DateRange dateRange]) {
    final dates = SplayTreeSet<DateTime>();

    for (final cabin in cabins) {
      dates.addAll(cabin.datesWithBookings(dateRange));
    }

    return dates;
  }

  Map<DateTime, int> get allCabinsBookingsCountPerDay {
    final bookingsPerDay = <DateTime, int>{};

    for (final cabin in cabins) {
      for (final bookingsCount in cabin.allBookingsCountPerDay.entries) {
        bookingsPerDay.update(
          bookingsCount.key,
          (count) => count + bookingsCount.value,
          ifAbsent: () => bookingsCount.value,
        );
      }
    }

    return SplayTreeMap<DateTime, int>.from(
      bookingsPerDay,
      (a, b) => (bookingsPerDay[b] ?? 0) - (bookingsPerDay[a] ?? 0),
    );
  }

  MapEntry<DateTime, int> get mostBookedDayEntry {
    final countEntries = allCabinsBookingsCountPerDay.entries;

    return countEntries.isEmpty ? null : countEntries.first;
  }

  Map<TimeOfDay, Duration> accumulatedTimeRangesOccupancy([
    DateRange dateRange,
  ]) {
    final timeRanges = <TimeOfDay, Duration>{};

    for (final cabin in cabins) {
      final accumulatedTimeRanges =
          cabin.accumulatedTimeRangesOccupancy(dateRange);

      for (final bookingTimeRange in accumulatedTimeRanges.entries) {
        timeRanges.update(
          bookingTimeRange.key,
          (duration) => duration + bookingTimeRange.value,
          ifAbsent: () => bookingTimeRange.value,
        );
      }
    }

    return timeRanges;
  }

  Set<TimeOfDay> mostOccupiedTimeRange([DateRange dateRange]) {
    final sortedTimeRanges = SplayTreeSet<MapEntry<TimeOfDay, Duration>>.from(
      accumulatedTimeRangesOccupancy(dateRange).entries,
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

  int get allBookingsCount {
    var count = 0;

    for (final cabin in cabins) {
      count += cabin.allBookings.length;
    }

    return count;
  }

  int get bookingsCount {
    var count = 0;

    for (final cabin in cabins) {
      count += cabin.bookings.length;
    }

    return count;
  }

  int get recurringBookingsCount {
    var count = 0;

    for (final cabin in cabins) {
      count += cabin.generatedBookingsFromRecurring.length;
    }

    return count;
  }

  Duration totalOccupiedDuration({DateTime dateTime, DateRange dateRange}) {
    var duration = const Duration();

    for (final cabin in cabins) {
      duration += cabin.occupiedDuration(
        dateTime: dateTime,
        dateRange: dateRange,
      );
    }

    return duration;
  }

  double occupancyPercent({
    @required TimeOfDay startTime,
    @required TimeOfDay endTime,
    Set<DateTime> dates,
  }) {
    if (cabins.isEmpty) return 0.0;

    final percents = <double>[];

    for (final cabin in cabins) {
      percents.add(
        cabin.occupancyPercent(
          startTime: startTime,
          endTime: endTime,
          dates: dates,
        ),
      );
    }

    return percents.reduce((value, element) => value + element) /
        percents.length;
  }

  int bookingsCountBetween(DateRange dateRange) {
    var count = 0;

    for (final cabin in cabins) {
      count += cabin.bookingsBetween(dateRange).length;
    }

    return count;
  }

  int recurringBookingsCountBetween(DateRange dateRange) {
    var count = 0;

    for (final cabin in cabins) {
      count += cabin.recurringBookingsBetween(dateRange).length;
    }

    return count;
  }

  void addCabin(
    Cabin cabin, {
    bool notify = true,
  }) {
    cabins.add(cabin);

    if (notify) notifyListeners();
  }

  void modifyCabin(
    Cabin cabin, {
    bool notify = true,
  }) {
    cabins.firstWhere((_cabin) => cabin.id == _cabin.id).replaceWith(cabin);

    if (notify) notifyListeners();
  }

  void removeCabinById(
    String id, {
    bool notify = true,
  }) {
    cabins.removeWhere((cabin) => cabin.id == id);

    if (notify) notifyListeners();
  }

  void emptyCabinsByIds(
    List<String> ids, {
    bool notify = true,
  }) {
    cabins
        .where((cabin) => ids.contains(cabin.id))
        .forEach((cabin) => cabin.emptyAllBookings());

    if (notify) notifyListeners();
  }

  void removeCabinsByIds(
    List<String> ids, {
    bool notify = true,
  }) {
    cabins.removeWhere((cabin) => ids.contains(cabin.id));

    if (notify) notifyListeners();
  }

  void addBooking(
    String cabinId,
    Booking booking, {
    bool notify = true,
  }) {
    cabinFromId(booking.cabinId ?? cabinId).addBooking(booking);

    if (notify) notifyListeners();
  }

  void addRecurringBooking(
    String cabinId,
    RecurringBooking recurringBooking, {
    bool notify = true,
  }) {
    cabinFromId(recurringBooking.cabinId ?? cabinId)
        .addRecurringBooking(recurringBooking);

    if (notify) notifyListeners();
  }

  void modifyBooking(
    String cabinId,
    Booking booking, {
    bool notify = true,
  }) {
    if (booking.cabinId == null || booking.cabinId == cabinId) {
      cabinFromId(cabinId).modifyBooking(booking);
    } else {
      cabinFromId(cabinId).removeBookingById(booking.id);
      cabinFromId(booking.cabinId).addBooking(booking);
    }

    if (notify) notifyListeners();
  }

  void modifyRecurringBooking(
    String cabinId,
    RecurringBooking recurringBooking, {
    bool notify = true,
  }) {
    if (recurringBooking.cabinId == null ||
        recurringBooking.cabinId == cabinId) {
      cabinFromId(cabinId).modifyRecurringBooking(recurringBooking);
    } else {
      cabinFromId(cabinId).removeRecurringBookingById(recurringBooking.id);
      cabinFromId(recurringBooking.cabinId)
          .addRecurringBooking(recurringBooking);
    }

    if (notify) notifyListeners();
  }

  void removeBookingById(
    String cabinId,
    String bookingId, {
    bool notify = true,
  }) {
    cabinFromId(cabinId).removeBookingById(bookingId);

    if (notify) notifyListeners();
  }

  void removeRecurringBookingById(
    String cabinId,
    String bookingId, {
    bool notify = true,
  }) {
    cabinFromId(cabinId).removeRecurringBookingById(bookingId);

    if (notify) notifyListeners();
  }

  void changeRecurringToBooking(
    String cabinId,
    Booking booking, {
    bool notify = true,
  }) {
    removeRecurringBookingById(cabinId, booking.id, notify: false);
    addBooking(cabinId, booking, notify: false);

    if (notify) notifyListeners();
  }

  void changeBookingToRecurring(
    String cabinId,
    RecurringBooking recurringBooking, {
    bool notify = true,
  }) {
    removeBookingById(cabinId, recurringBooking.id, notify: false);
    addRecurringBooking(cabinId, recurringBooking, notify: false);

    if (notify) notifyListeners();
  }

  @override
  Future<Set<Cabin>> readFromFile() async {
    try {
      final file = await fileManager.localFile(fileName);
      final content = await file.readAsString();

      final cabins = await _parseCabins(content);

      return SplayTreeSet.from(cabins);
    } catch (e) {
      return SplayTreeSet();
    }
  }

  @override
  Future<int> loadFromFile() async {
    cabins = await readFromFile();

    notifyListeners();

    return cabins.length;
  }

  @override
  Future<bool> writeToFile() async {
    final file = await fileManager.localFile(fileName);

    await file.writeAsString(
      json.encode(cabinsToMapList()),
    );

    return true;
  }
}
