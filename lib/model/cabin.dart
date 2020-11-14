import 'package:flutter/material.dart';

import 'booking.dart';

class Cabin {
  final String id;
  final int number;
  final Map<String, int> components;
  final List<Booking> bookings;

  Cabin({
    this.id,
    @required this.number,
    this.components = const {},
    this.bookings = const [],
  });
}
