import 'package:cabin_booking/model/cabin.dart';
import 'package:flutter/material.dart';
import 'package:cabin_booking/model/data/cabin_data.dart' as data;

class CabinManager with ChangeNotifier {
  List<Cabin> cabins;

  CabinManager({this.cabins = const []});

  CabinManager.dummy() {
    cabins = data.cabins;
  }

  Cabin getCabinById(String id) => cabins.firstWhere((cabin) => cabin.id == id);

  void addCabin(Cabin cabin) {
    cabins.add(cabin);
    notifyListeners();
  }

  void removeCabinById(String id) {
    cabins.removeWhere((cabin) => cabin.id == id);
    notifyListeners();
  }

  void removeBookingById(String cabinId, String bookingId) {
    getCabinById(cabinId).bookingManager.removeBookingById(bookingId);
    notifyListeners();
  }
}
