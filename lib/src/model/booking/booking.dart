import 'package:cabin_booking/utils/date_time_extension.dart';
import 'package:cabin_booking/utils/time_of_day_extension.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../date/date_range.dart';
import '../item.dart';

abstract class _JsonFields {
  static const description = 'de';
  static const date = 'd';
  static const startTime = 'st';
  static const endTime = 'et';
  static const status = 's';
  static const isLocked = 'il';
}

class Booking extends Item {
  String? description;
  DateTime? date;
  TimeOfDay? startTime;
  TimeOfDay? endTime;
  BookingStatus status;
  bool isLocked;
  String? cabinId;

  String? recurringBookingId;
  int? recurringNumber;
  int? recurringTotalTimes;

  Booking({
    String? id,
    this.description,
    this.date,
    this.startTime,
    this.endTime,
    this.status = BookingStatus.pending,
    this.isLocked = false,
    this.cabinId,
    this.recurringBookingId,
    this.recurringNumber,
    this.recurringTotalTimes,
  }) : super(id: id);

  Booking.from(Map<String, dynamic> other)
      : description = other[_JsonFields.description] as String?,
        date = DateTime.tryParse(other[_JsonFields.date] as String),
        startTime =
            TimeOfDayExtension.tryParse(other[_JsonFields.startTime] as String),
        endTime =
            TimeOfDayExtension.tryParse(other[_JsonFields.endTime] as String),
        status = BookingStatus.values[other[_JsonFields.status] as int],
        isLocked = other[_JsonFields.isLocked] as bool,
        super.from(other);

  @override
  Map<String, dynamic> toJson() => {
        ...super.toJson(),
        _JsonFields.description: description,
        _JsonFields.date: date!.toIso8601String().split('T').first,
        _JsonFields.startTime: startTime!.format24Hour(),
        _JsonFields.endTime: endTime!.format24Hour(),
        _JsonFields.status: status.index,
        _JsonFields.isLocked: isLocked,
      };

  DateTime get startDateTime => date!.addTimeOfDay(startTime);

  DateTime get endDateTime => date!.addTimeOfDay(endTime);

  Duration get duration => endDateTime.difference(startDateTime);

  Map<TimeOfDay, Duration> get hoursSpan {
    final timeRanges = <TimeOfDay, Duration>{};

    var runTime = startTime;
    var runDuration = Duration.zero;

    while (runDuration < duration) {
      final nextHour = TimeOfDay(
        hour: (runTime!.hour + 1) % TimeOfDay.hoursPerDay,
        minute: 0,
      );

      final nextTime =
          nextHour.difference(endTime!) <= Duration.zero ? endTime! : nextHour;
      final currentDuration = runTime.difference(nextTime);

      runDuration += currentDuration;

      timeRanges.addAll({
        runTime.replacing(minute: 0): currentDuration,
      });

      runTime = nextTime;
    }

    return timeRanges;
  }

  String get timeRange => '${startTime!.format24Hour()}'
      '–${endTime!.format24Hour()}';

  String get dateTimeRange => '${DateFormat.yMd().format(date!)} $timeRange';

  bool isOn(DateTime dateTime) => date?.isSameDateAs(dateTime) ?? false;

  bool isBetween(DateRange dateRange) => dateRange.includes(startDateTime);

  bool collidesWith(Booking booking) =>
      startDateTime.isBefore(booking.endDateTime) &&
      endDateTime.isAfter(booking.startDateTime);

  @override
  Booking copyWith({
    String? id,
    String? description,
    DateTime? date,
    TimeOfDay? startTime,
    TimeOfDay? endTime,
    BookingStatus? status,
    bool? isLocked,
    String? cabinId,
  }) =>
      Booking(
        id: id ?? this.id,
        description: description ?? this.description,
        date: date ?? this.date,
        startTime: startTime ?? this.startTime,
        endTime: endTime ?? this.endTime,
        status: status ?? this.status,
        isLocked: isLocked ?? this.isLocked,
        cabinId: cabinId ?? this.cabinId,
      );

  @override
  void replaceWith(covariant Booking item) {
    description = item.description;
    date = item.date;
    startTime = item.startTime;
    endTime = item.endTime;
    status = item.status;
    isLocked = item.isLocked;

    super.replaceWith(item);
  }

  @override
  String toString() =>
      [if (isLocked) '🔒', description, dateTimeRange].join(' ');

  @override
  int compareTo(covariant Booking other) =>
      startDateTime.compareTo(other.startDateTime);
}

enum BookingStatus { pending, confirmed, cancelled }