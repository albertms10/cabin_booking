import 'package:cabin_booking/model/item.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DateRange extends Item {
  DateTime startDate;
  DateTime endDate;

  DateRange({
    String id,
    this.startDate,
    this.endDate,
  })  : assert(
          startDate != null && endDate != null
              ? endDate.isAfter(startDate)
              : true,
        ),
        super(id: id) {
    endDate ??= startDate;
  }

  DateRange.from(Map<String, dynamic> other)
      : startDate = DateTime.tryParse(other['startDate'] as String),
        endDate = DateTime.tryParse(other['endDate'] as String),
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

  Duration get duration => endDate.difference(startDate);

  static List<DateTime> rangeDateTimeList(
    DateTime start,
    DateTime end, {
    Duration interval = const Duration(days: 1),
  }) {
    assert(end.isAfter(start));

    final dates = <DateTime>[start];
    var runDate = start;

    while (runDate.isBefore(end)) {
      runDate = runDate.add(interval);
      dates.add(runDate);
    }

    return dates;
  }

  List<DateTime> dateTimeList({Duration interval = const Duration(days: 1)}) =>
      DateRange.rangeDateTimeList(startDate, endDate, interval: interval);

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

  @override
  int compareTo(covariant DateRange other) =>
      startDate.compareTo(other.startDate);
}
