import 'package:cabin_booking/model/booking.dart';
import 'package:cabin_booking/model/cabin.dart';
import 'package:flutter/material.dart';
import 'package:cabin_booking/model/data/cabin_data.dart' as data;

class CabinManager with ChangeNotifier {
  List<Cabin> cabins;

  CabinManager({this.cabins});

  CabinManager.dummy() : cabins = data.cabins;

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
}
