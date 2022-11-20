import 'package:cabin_booking/utils/date_time_extension.dart';
import 'package:cabin_booking/utils/time_of_day_extension.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../date/date_range.dart';
import '../item.dart';

abstract class _JsonFields {
  static const description = 'de';
  static const startDateTime = 'sd';
  static const endDateTime = 'ed';
  static const isLocked = 'il';
}

class Booking extends Item {
  String? description;
  DateTime? startDateTime;
  DateTime? endDateTime;
  bool isLocked;
  String? cabinId;

  String? recurringBookingId;
  int? recurringNumber;
  int? recurringTotalTimes;

  Booking({
    super.id,
    this.description,
    this.startDateTime,
    this.endDateTime,
    this.isLocked = false,
    this.cabinId,
    this.recurringBookingId,
    this.recurringNumber,
    this.recurringTotalTimes,
  });

  Booking.from(super.other)
      : description = other[_JsonFields.description] as String?,
        startDateTime = DateTime.tryParse(
          other[_JsonFields.startDateTime] as String? ?? '',
        ),
        endDateTime =
            DateTime.tryParse(other[_JsonFields.endDateTime] as String? ?? ''),
        isLocked = other[_JsonFields.isLocked] as bool,
        super.from();

  @override
  Map<String, dynamic> toJson() => {
        ...super.toJson(),
        _JsonFields.description: description,
        _JsonFields.startDateTime: startDateTime?.toIso8601String(),
        _JsonFields.endDateTime: endDateTime?.toIso8601String(),
        _JsonFields.isLocked: isLocked,
      };

  /// Alias for [startDateTime].
  DateTime? get date => startDateTime;

  TimeOfDay get startTime => TimeOfDay.fromDateTime(startDateTime!);

  TimeOfDay get endTime => TimeOfDay.fromDateTime(endDateTime!);

  Duration get duration => endDateTime!.difference(startDateTime!);

  Map<TimeOfDay, Duration> get hoursSpan {
    final timeRanges = <TimeOfDay, Duration>{};

    var runTime = startTime;
    var runDuration = Duration.zero;

    while (runDuration < duration) {
      final nextHour = TimeOfDay(
        hour: (runTime.hour + 1) % TimeOfDay.hoursPerDay,
        minute: 0,
      );

      final nextTime =
          endTime.difference(nextHour).isNegative ? endTime : nextHour;
      final currentDuration = nextTime.difference(runTime);

      runDuration += currentDuration;

      timeRanges.addAll({
        runTime.replacing(minute: 0): currentDuration,
      });

      runTime = nextTime;
    }

    return timeRanges;
  }

  String get timeRange => '${startTime.format24Hour()}'
      '–${endTime.format24Hour()}';

  String get dateTimeRange =>
      '${DateFormat.yMd().format(startDateTime!)} $timeRange';

  bool isOn(DateTime dateTime) =>
      startDateTime?.isSameDateAs(dateTime) ?? false;

  bool isBetween(DateRanger dateRange) => dateRange.includes(startDateTime!);

  bool collidesWith(Booking booking) =>
      startDateTime!.isBefore(booking.endDateTime!) &&
      endDateTime!.isAfter(booking.startDateTime!);

  @override
  Booking copyWith({
    String? id,
    String? description,
    DateTime? startDateTime,
    DateTime? endDateTime,
    bool? isLocked,
    String? cabinId,
  }) =>
      Booking(
        id: id ?? this.id,
        description: description ?? this.description,
        startDateTime: startDateTime ?? this.startDateTime,
        endDateTime: endDateTime ?? this.endDateTime,
        isLocked: isLocked ?? this.isLocked,
        cabinId: cabinId ?? this.cabinId,
      );

  @override
  void replaceWith(covariant Booking item) {
    description = item.description;
    startDateTime = item.startDateTime;
    endDateTime = item.endDateTime;
    isLocked = item.isLocked;

    super.replaceWith(item);
  }

  @override
  String toString() =>
      [if (isLocked) '🔒', description, dateTimeRange].join(' ');

  @override
  int compareTo(covariant Booking other) =>
      startDateTime!.compareTo(other.startDateTime!);
}
