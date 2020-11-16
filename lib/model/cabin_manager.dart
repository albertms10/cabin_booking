import 'dart:convert' show json;

import 'package:cabin_booking/model/booking.dart';
import 'package:cabin_booking/model/cabin.dart';
import 'package:cabin_booking/model/file_manager.dart';
import 'package:flutter/material.dart';

class CabinManager with ChangeNotifier, FileManager {
  List<Cabin> cabins;

  CabinManager({this.cabins}) {
    if (cabins == null) cabins = List<Cabin>();
  }

  List<Cabin> _generateCabins(int number) => [
        for (int i = 1; i <= number; i++) Cabin(id: '$i', number: i),
      ];

  List<Cabin> parseCabins(String jsonString) =>
      json.decode(jsonString).map<Cabin>((json) => Cabin.from(json)).toList();

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
    getFromId(booking.cabinId ?? cabinId).bookingManager.addBooking(booking);

    // TODO: Improve notifier
    notifyListeners();
  }

  void modifyBooking(String cabinId, Booking booking) {
    if (booking.cabinId == null || booking.cabinId == cabinId) {
      getFromId(cabinId).bookingManager.modifyBooking(booking);
    } else {
      getFromId(cabinId).bookingManager.removeBookingById(booking.id);
      getFromId(booking.cabinId).bookingManager.addBooking(booking);
    }

    // TODO: Improve notifier
    notifyListeners();
  }

  void removeBookingById(String cabinId, String bookingId) {
    getFromId(cabinId).bookingManager.removeBookingById(bookingId);

    // TODO: Improve notifier
    notifyListeners();
  }

  static final _fileName = 'cabin_manager';
  static final _defaultCabinNumber = 6;

  void writeCabinsToFile() async {
    final file = await localFile(_fileName);

    file.writeAsString(
      json.encode(cabinsToMapList()),
    );
  }

  Future<List<Cabin>> readCabinsFromFile() async {
    try {
      final file = await localFile(_fileName);

      final cabins = parseCabins(await file.readAsString());

      return cabins.length > 0 ? cabins : _generateCabins(_defaultCabinNumber);
    } catch (e) {
      return _generateCabins(_defaultCabinNumber);
    }
  }

  void loadCabinsFromFile() async {
    cabins = await readCabinsFromFile();

    notifyListeners();
  }
}
