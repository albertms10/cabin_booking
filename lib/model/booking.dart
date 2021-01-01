import 'package:cabin_booking/model/item.dart';
import 'package:cabin_booking/utils/date.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Booking extends Item {
  String description;
  DateTime date;
  TimeOfDay startTime;
  TimeOfDay endTime;
  BookingStatus status;
  bool isDisabled;
  String cabinId;

  String recurringBookingId;
  int recurringNumber;
  int recurringTotalTimes;

  Booking({
    String id,
    this.description,
    this.date,
    this.startTime,
    this.endTime,
    this.status = BookingStatus.Pending,
    this.isDisabled = false,
    this.cabinId,
    this.recurringBookingId,
    this.recurringNumber,
    this.recurringTotalTimes,
  }) : super(id: id);

  Booking.from(Map<String, dynamic> other)
      : description = other['description'] as String,
        date = DateTime.tryParse(other['date'] as String),
        startTime = tryParseTimeOfDay(other['startTime'] as String),
        endTime = tryParseTimeOfDay(other['endTime'] as String),
        status = BookingStatus.values[other['status'] as int],
        isDisabled = other['isDisabled'] as bool,
        super.from(other);

  @override
  Map<String, dynamic> toMap() => {
        ...super.toMap(),
        'description': description,
        'date': date.toIso8601String().split('T').first,
        'startTime': formatTimeOfDay(startTime),
        'endTime': formatTimeOfDay(endTime),
        'status': status.index,
        'isDisabled': isDisabled,
      };

  DateTime get startDateTime => tryParseDateTimeWithTimeOfDay(
        dateTime: date,
        timeOfDay: startTime,
      );

  DateTime get endDateTime => tryParseDateTimeWithTimeOfDay(
        dateTime: date,
        timeOfDay: endTime,
      );

  Duration get duration => endDateTime.difference(startDateTime);

  Map<TimeOfDay, Duration> get hoursSpan {
    final timeRanges = <TimeOfDay, Duration>{};

    var runningTime = startTime;
    var runningDuration = const Duration();

    while (runningDuration < duration) {
      final nextHour = TimeOfDay(
        hour: (runningTime.hour + 1) % TimeOfDay.hoursPerDay,
        minute: 0,
      );

      final nextTime =
          durationBetweenTimesOfDay(nextHour, endTime) <= const Duration()
              ? endTime
              : nextHour;

      final currentDuration = durationBetweenTimesOfDay(runningTime, nextTime);

      runningDuration += currentDuration;

      timeRanges.addAll({
        runningTime.replacing(minute: 0): currentDuration,
      });

      runningTime = nextTime;
    }

    return timeRanges;
  }

  String get timeRange =>
      '${formatTimeOfDay(startTime)}–${formatTimeOfDay(endTime)}';

  String get dateTimeRange => '${DateFormat.yMd().format(date)} $timeRange';

  bool isOn(DateTime dateTime) => isSameDay(date, dateTime);

  bool collidesWith(Booking booking) =>
      startDateTime.isBefore(booking.endDateTime) &&
      endDateTime.isAfter(booking.startDateTime);

  @override
  Booking copyWith({
    String description,
    DateTime date,
    TimeOfDay startTime,
    TimeOfDay endTime,
    BookingStatus status,
    bool isDisabled,
    String cabinId,
  }) =>
      Booking(
        id: id,
        description: description ?? this.description,
        date: date ?? this.date,
        startTime: startTime ?? this.startTime,
        endTime: endTime ?? this.endTime,
        status: status ?? this.status,
        isDisabled: isDisabled ?? this.isDisabled,
        cabinId: cabinId ?? this.cabinId,
      );

  @override
  void replaceWith(covariant Booking booking) {
    description = booking.description;
    date = booking.date;
    startTime = booking.startTime;
    endTime = booking.endTime;
    status = booking.status;
    isDisabled = booking.isDisabled;

    super.replaceWith(booking);
  }

  @override
  String toString() =>
      '$description $dateTimeRange${isDisabled ? ' (disabled)' : ''}';

  @override
  int compareTo(covariant Booking other) =>
      startDateTime.compareTo(other.startDateTime);
}

enum BookingStatus { Pending, Confirmed, Cancelled }
