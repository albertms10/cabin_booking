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

  List<Cabin> _generateCabins(int number) => [
        for (var i = 1; i <= number; i++) Cabin(number: i),
      ];

  List<Map<String, dynamic>> cabinsToMapList() =>
      cabins.map((cabin) => cabin.toMap()).toList();

  Cabin getFromId(String id) => cabins.firstWhere((cabin) => cabin.id == id);

  Cabin getFromNumber(int number) =>
      cabins.firstWhere((cabin) => cabin.number == number);

  List<DateTime> allCabinsDatesWithBookings() {
    final dates = <DateTime>[];

    for (final cabin in cabins) {
      for (final dateTime in cabin.datesWithBookings()) {
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

  void removeCabinById(String id) {
    cabins.removeWhere((cabin) => cabin.id == id);

    notifyListeners();
  }

  void removeCabinsByIds(List<String> ids) {
    cabins.removeWhere((cabin) => ids.contains(cabin.id));

    notifyListeners();
  }

  void addBooking(String cabinId, Booking booking) {
    getFromId(booking.cabinId ?? cabinId).addBooking(booking);

    // TODO: Improve notifier
    notifyListeners();
  }

  void addRecurringBooking(String cabinId, RecurringBooking recurringBooking) {
    getFromId(recurringBooking.cabinId ?? cabinId)
        .addRecurringBooking(recurringBooking);

    // TODO: Improve notifier
    notifyListeners();
  }

  void modifyBooking(String cabinId, Booking booking) {
    if (booking.cabinId == null || booking.cabinId == cabinId) {
      getFromId(cabinId).modifyBooking(booking);
    } else {
      getFromId(cabinId).removeBookingById(booking.id);
      getFromId(booking.cabinId).addBooking(booking);
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
      getFromId(cabinId).modifyRecurringBooking(recurringBooking);
    } else {
      getFromId(cabinId).removeRecurringBookingById(recurringBooking.id);
      getFromId(recurringBooking.cabinId).addRecurringBooking(recurringBooking);
    }

    // TODO: Improve notifier
    notifyListeners();
  }

  void removeBookingById(String cabinId, String bookingId) {
    getFromId(cabinId).removeBookingById(bookingId);

    // TODO: Improve notifier
    notifyListeners();
  }

  void removeRecurringBookingById(String cabinId, String bookingId) {
    getFromId(cabinId).removeRecurringBookingById(bookingId);

    // TODO: Improve notifier
    notifyListeners();
  }

  static final _fileName = 'cabin_manager';
  static final _defaultCabinNumber = 6;

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

      return cabins.isNotEmpty ? cabins : _generateCabins(_defaultCabinNumber);
    } catch (e) {
      return _generateCabins(_defaultCabinNumber);
    }
  }

  Future<bool> loadCabinsFromFile() async {
    cabins = await readCabinsFromFile();

    notifyListeners();

    return true;
  }
}
