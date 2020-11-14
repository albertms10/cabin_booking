import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

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

  Duration get duration => dateEnd.difference(dateStart);

  String get dateRange =>
      '${DateFormat('HH:mm').format(dateStart)}–${DateFormat('HH:mm').format(dateEnd)}';
}
