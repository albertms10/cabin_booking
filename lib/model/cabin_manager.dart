import 'dart:convert' show json;

import 'package:cabin_booking/model/booking.dart';
import 'package:cabin_booking/model/cabin.dart';
import 'package:cabin_booking/model/file_manager.dart';
import 'package:cabin_booking/model/recurring_booking.dart';
import 'package:cabin_booking/utils/date.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

List<Cabin> _parseCabins(String jsonString) =>
    json.decode(jsonString).map<Cabin>((json) => Cabin.from(json)).toList();

class CabinManager with ChangeNotifier, FileManager {
  List<Cabin> cabins;

  CabinManager({this.cabins}) {
    cabins ??= <Cabin>[];
  }

  List<Map<String, dynamic>> cabinsToMapList() =>
      cabins.map((cabin) => cabin.toMap()).toList();

  Cabin fromId(String id) => cabins.firstWhere((cabin) => cabin.id == id);

  static int _sortCabins(Cabin a, Cabin b) => a.number.compareTo(b.number);

  int get lastCabinNumber => cabins.isNotEmpty ? cabins.last.number : 0;

  List<DateTime> get allCabinsDatesWithBookings {
    final dates = <DateTime>[];

    for (final cabin in cabins) {
      for (final dateTime in cabin.datesWithBookings) {
        final hasDate = dates.firstWhere(
              (date) => isSameDay(date, dateTime),
              orElse: () => null,
            ) !=
            null;

        if (!hasDate) dates.add(dateTime);
      }
    }

    return dates;
  }

  void addCabin(Cabin cabin) {
    cabins.add(cabin);

    notifyListeners();
  }

  void modifyCabin(Cabin cabin) {
    cabins.firstWhere((_cabin) => cabin.id == _cabin.id).replaceWith(cabin);

    cabins.sort(_sortCabins);

    notifyListeners();
  }

  void removeCabinById(String id) {
    cabins.removeWhere((cabin) => cabin.id == id);

    notifyListeners();
  }

  void emptyCabinsByIds(List<String> ids) {
    cabins
        .where((cabin) => ids.contains(cabin.id))
        .forEach((cabin) => cabin.emptyAllBookings());

    notifyListeners();
  }

  void removeCabinsByIds(List<String> ids) {
    cabins.removeWhere((cabin) => ids.contains(cabin.id));

    notifyListeners();
  }

  void addBooking(String cabinId, Booking booking) {
    fromId(booking.cabinId ?? cabinId).addBooking(booking);

    // TODO: Improve notifier
    notifyListeners();
  }

  void addRecurringBooking(String cabinId, RecurringBooking recurringBooking) {
    fromId(recurringBooking.cabinId ?? cabinId)
        .addRecurringBooking(recurringBooking);

    // TODO: Improve notifier
    notifyListeners();
  }

  void modifyBooking(String cabinId, Booking booking) {
    if (booking.cabinId == null || booking.cabinId == cabinId) {
      fromId(cabinId).modifyBooking(booking);
    } else {
      fromId(cabinId).removeBookingById(booking.id);
      fromId(booking.cabinId).addBooking(booking);
    }

    // TODO: Improve notifier
    notifyListeners();
  }

  void modifyRecurringBooking(
    String cabinId,
    RecurringBooking recurringBooking,
  ) {
    if (recurringBooking.cabinId == null ||
        recurringBooking.cabinId == cabinId) {
      fromId(cabinId).modifyRecurringBooking(recurringBooking);
    } else {
      fromId(cabinId).removeRecurringBookingById(recurringBooking.id);
      fromId(recurringBooking.cabinId).addRecurringBooking(recurringBooking);
    }

    // TODO: Improve notifier
    notifyListeners();
  }

  void removeBookingById(String cabinId, String bookingId) {
    fromId(cabinId).removeBookingById(bookingId);

    // TODO: Improve notifier
    notifyListeners();
  }

  void removeRecurringBookingById(String cabinId, String bookingId) {
    fromId(cabinId).removeRecurringBookingById(bookingId);

    // TODO: Improve notifier
    notifyListeners();
  }

  static final _fileName = 'cabin_manager';

  Future<bool> writeCabinsToFile() async {
    final file = await localFile(_fileName);

    await file.writeAsString(
      json.encode(cabinsToMapList()),
    );

    return true;
  }

  Future<List<Cabin>> readCabinsFromFile() async {
    try {
      final file = await localFile(_fileName);

      final cabins = await compute(_parseCabins, await file.readAsString());

      return cabins;
    } catch (e) {
      return [];
    }
  }

  Future<int> loadCabinsFromFile() async {
    cabins = await readCabinsFromFile();

    notifyListeners();

    return cabins.length;
  }
}
