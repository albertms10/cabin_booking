import 'package:flutter/material.dart';

class Booking {
  final String id;
  final DateTime dateStart;
  final DateTime dateEnd;
  final String studentName;

  Booking({
    this.id,
    @required this.dateStart,
    this.dateEnd,
    @required this.studentName,
  });
}
