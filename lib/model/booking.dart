import 'package:cabin_booking/utils/date.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

class Booking {
  String id;
  String studentName;
  DateTime date;
  TimeOfDay timeStart;
  TimeOfDay timeEnd;
  bool isDisabled;
  String cabinId;
  String recurringBookingId;

  Booking({
    this.id,
    this.studentName,
    this.date,
    this.timeStart,
    this.timeEnd,
    this.isDisabled = false,
    this.cabinId,
    this.recurringBookingId,
  }) {
    id ??= Uuid().v4();
  }

  Booking.from(Map<String, dynamic> other)
      : id = other['id'],
        studentName = other['studentName'],
        date = DateTime.tryParse(other['date']),
        timeStart = tryParseTimeOfDay(other['timeStart']),
        timeEnd = tryParseTimeOfDay(other['timeEnd']),
        isDisabled = other['isDisabled'];

  Map<String, dynamic> toMap() => {
        'id': id,
        'studentName': studentName,
        'date': date.toIso8601String().split('T')[0],
        'timeStart': formatTimeOfDay(timeStart),
        'timeEnd': formatTimeOfDay(timeEnd),
        'isDisabled': isDisabled,
      };

  DateTime get dateStart => tryParseDateTimeWithFormattedTimeOfDay(
        dateTime: date,
        formattedTimeOfDay: formatTimeOfDay(timeStart),
      );

  DateTime get dateEnd => tryParseDateTimeWithFormattedTimeOfDay(
        dateTime: date,
        formattedTimeOfDay: formatTimeOfDay(timeEnd),
      );

  Duration get duration => dateEnd.difference(dateStart);

  String get timeRange =>
      '${formatTimeOfDay(timeStart)}–${formatTimeOfDay(timeEnd)}';

  String get dateRange => '${DateFormat.yMd().format(date)} $timeRange';

  bool isOn(DateTime dateTime) => isSameDay(date, dateTime);

  bool collidesWith(Booking booking) =>
      dateStart.isBefore(booking.dateEnd) && dateEnd.isAfter(booking.dateStart);

  Booking movedTo(DateTime dateTime) => Booking(
        id: id,
        studentName: studentName,
        date: dateTime,
        timeStart: TimeOfDay.fromDateTime(dateStart),
        timeEnd: TimeOfDay.fromDateTime(dateEnd),
        isDisabled: isDisabled,
        cabinId: cabinId,
      );

  void replaceWith(Booking booking) {
    studentName = booking.studentName;
    date = booking.date;
    timeStart = booking.timeStart;
    timeEnd = booking.timeEnd;
    isDisabled = booking.isDisabled;
  }

  @override
  String toString() =>
      '$studentName $dateRange ${isDisabled ? ' (disabled)' : ''}';

  @override
  bool operator ==(other) => other is Booking && id == other.id;

  @override
  int get hashCode => id.hashCode;
}
