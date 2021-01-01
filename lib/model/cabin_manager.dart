import 'dart:collection';
import 'dart:convert' show json;

import 'package:cabin_booking/model/booking.dart';
import 'package:cabin_booking/model/cabin.dart';
import 'package:cabin_booking/model/file_manager.dart';
import 'package:cabin_booking/model/recurring_booking.dart';
import 'package:cabin_booking/model/writable_manager.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

Iterable<Cabin> _parseCabins(String jsonString) =>
    json.decode(jsonString).map<Cabin>((json) => Cabin.from(json));

class CabinManager extends WritableManager<Set<Cabin>>
    with ChangeNotifier, FileManager {
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

  Set<DateTime> get allCabinsDatesWithBookings {
    final dates = SplayTreeSet<DateTime>();

    for (final cabin in cabins) {
      dates.addAll(cabin.datesWithBookings);
    }

    return dates;
  }

  Map<DateTime, int> get allCabinsBookingsCountPerDay {
    final bookingsPerDay = <DateTime, int>{};

    for (final cabin in cabins) {
      for (final bookingsCount in cabin.allBookingsCountPerDay.entries) {
        if (bookingsPerDay.containsKey(bookingsCount.key)) {
          bookingsPerDay[bookingsCount.key] += bookingsCount.value;
        } else {
          bookingsPerDay[bookingsCount.key] = bookingsCount.value;
        }
      }
    }

    return bookingsPerDay;
  }

  MapEntry<DateTime, int> get mostBookedDayEntry {
    final sortedCountList = allCabinsBookingsCountPerDay.entries.toList()
      ..sort((a, b) => b.value - a.value);

    return sortedCountList.isEmpty ? null : sortedCountList.first;
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
      final file = await localFile(fileName);
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
    final file = await localFile(fileName);

    await file.writeAsString(
      json.encode(cabinsToMapList()),
    );

    return true;
  }
}
