import 'package:cabin_booking/model/item.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class SchoolYear extends Item {
  final DateTime startDate;
  final DateTime endDate;

  SchoolYear({
    String id,
    @required this.startDate,
    @required this.endDate,
  }) : super(id: id);

  SchoolYear.from(Map<String, dynamic> other)
      : startDate = DateTime.tryParse(other['startDate']),
        endDate = DateTime.tryParse(other['endDate']),
        super.from(other);

  @override
  Map<String, dynamic> toMap() => {
        ...super.toMap(),
        'startDate': startDate.toIso8601String().split('T').first,
        'endDate': endDate.toIso8601String().split('T').first,
      };

  @override
  SchoolYear copyWith({
    DateTime startDate,
    DateTime endDate,
  }) =>
      SchoolYear(
        startDate: startDate ?? this.startDate,
        endDate: endDate ?? this.endDate,
      );

  @override
  String toString() =>
      '${DateFormat.y().format(startDate)}–${DateFormat.y().format(endDate)}';

  @override
  bool operator ==(other) =>
      other is SchoolYear &&
      startDate == other.startDate &&
      endDate == other.endDate;

  @override
  int get hashCode => hashValues(startDate, endDate);
}
