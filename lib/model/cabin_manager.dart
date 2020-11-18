import 'dart:convert' show json;

import 'package:cabin_booking/model/booking.dart';
import 'package:cabin_booking/model/cabin.dart';
import 'package:cabin_booking/model/file_manager.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

List<Cabin> _parseCabins(String jsonString) =>
    json.decode(jsonString).map<Cabin>((json) => Cabin.from(json)).toList();

class CabinManager with ChangeNotifier, FileManager {
  List<Cabin> cabins;

  CabinManager({this.cabins}) {
    if (cabins == null) cabins = <Cabin>[];
  }

  List<Cabin> _generateCabins(int number) => [
        for (int i = 1; i <= number; i++) Cabin(id: Uuid().v4(), number: i),
      ];

  List<Map<String, dynamic>> cabinsToMapList() =>
      cabins.map((cabin) => cabin.toMap()).toList();

  Cabin getFromId(String id) => cabins.firstWhere((cabin) => cabin.id == id);

  Cabin getFromNumber(int number) =>
      cabins.firstWhere((cabin) => cabin.number == number);

  void addCabin(Cabin cabin) {
    cabins.add(cabin);

    notifyListeners();
  }

  void removeCabinById(String id) {
    cabins.removeWhere((cabin) => cabin.id == id);

    notifyListeners();
  }

  void addBooking(String cabinId, Booking booking) {
    getFromId(booking.cabinId ?? cabinId).addBooking(booking);

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

  void removeBookingById(String cabinId, String bookingId) {
    getFromId(cabinId).removeBookingById(bookingId);

    // TODO: Improve notifier
    notifyListeners();
  }

  static final _fileName = 'cabin_manager';
  static final _defaultCabinNumber = 6;

  Future<bool> writeCabinsToFile() async {
    final file = await localFile(_fileName);

    file.writeAsString(
      json.encode(cabinsToMapList()),
    );

    return true;
  }

  Future<List<Cabin>> readCabinsFromFile() async {
    try {
      final file = await localFile(_fileName);

      final cabins = await compute(_parseCabins, await file.readAsString());

      return cabins.length > 0 ? cabins : _generateCabins(_defaultCabinNumber);
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
