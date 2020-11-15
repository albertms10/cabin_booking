import 'package:cabin_booking/model/cabin.dart';
import 'package:flutter/material.dart';
import 'package:cabin_booking/model/data/cabin_data.dart' as data;

class CabinManager with ChangeNotifier {
  List<Cabin> cabins;

  CabinManager({this.cabins = const []});

  CabinManager.dummy() {
    cabins = data.cabins;
  }

  void addCabin(Cabin cabin) {
    cabins.add(cabin);
    notifyListeners();
  }

  void removeCabin(int index) {
    cabins.removeAt(index);
    notifyListeners();
  }
}
