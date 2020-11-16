import 'dart:convert' show json;
import 'dart:io';

import 'package:cabin_booking/model/booking.dart';
import 'package:cabin_booking/model/cabin.dart';
import 'package:cabin_booking/model/data/cabin_data.dart' as data;
import 'package:cabin_booking/model/file_manager.dart';
import 'package:flutter/material.dart';

class CabinManager with ChangeNotifier, FileManager {
  List<Cabin> cabins;

  CabinManager({this.cabins}) {
    if (cabins == null) cabins = List<Cabin>();
  }

  CabinManager.dummy() : cabins = data.cabins;

  List<Cabin> parseCabins(String jsonString) => json
      .decode(jsonString)
      .map<Cabin>((json) => Cabin.from(json))
      .toList();

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

  static final fileName = 'cabin_manager';

  Future<File> writeCabinsToFile() async {
    final file = await localFile(fileName);

    return file.writeAsString(
      json.encode(cabinsToMapList()),
    );
  }

  Future<List<Cabin>> readCabinsFromFile() async {
    try {
      final file = await localFile(fileName);

      String contents = await file.readAsString();

      return parseCabins(contents);
    } catch (e) {
      print(e);
      return List<Cabin>();
    }
  }

  void loadCabinsFromFile() async {
    cabins = await readCabinsFromFile();

    notifyListeners();
  }
}
