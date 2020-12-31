import 'package:cabin_booking/model/item.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DateRange extends Item {
  final DateTime startDate;
  final DateTime endDate;

  DateRange({
    String id,
    @required this.startDate,
    @required this.endDate,
  })  : assert(startDate != null),
        assert(endDate != null),
        super(id: id);

  DateRange.from(Map<String, dynamic> other)
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
  DateRange copyWith({
    DateTime startDate,
    DateTime endDate,
  }) =>
      DateRange(
        id: id,
        startDate: startDate ?? this.startDate,
        endDate: endDate ?? this.endDate,
      );

  bool includes(DateTime dateTime) =>
      startDate.isBefore(dateTime) && endDate.isAfter(dateTime);

  @override
  String toString() =>
      '${DateFormat.yMd().format(startDate)} – ${DateFormat.yMd().format(endDate)}';

  @override
  bool operator ==(other) =>
      other is DateRange &&
      startDate == other.startDate &&
      endDate == other.endDate;

  @override
  int get hashCode => hashValues(startDate, endDate);
}
