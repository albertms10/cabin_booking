import 'package:cabin_booking/utils/date_time_extension.dart';
import 'package:cabin_booking/utils/time_of_day_extension.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../date/date_ranger.dart';
import '../item.dart';

abstract class _JsonFields {
  static const description = 'de';
  static const startDate = 'sd';
  static const endDate = 'ed';
  static const isLocked = 'il';
}

abstract class Booking extends Item with DateRanger {
  String? description;

  @override
  DateTime? startDate;

  @override
  DateTime? endDate;

  bool isLocked;
  String? cabinId;

  String? recurringBookingId;
  int? recurringNumber;
  int? recurringTotalTimes;

  Booking({
    super.id,
    this.description,
    this.startDate,
    this.endDate,
    this.isLocked = false,
    this.cabinId,
    this.recurringBookingId,
    this.recurringNumber,
    this.recurringTotalTimes,
  });

  Booking.from(super.other)
      : description = other[_JsonFields.description] as String?,
        startDate = DateTime.tryParse(
          other[_JsonFields.startDate] as String? ?? '',
        ),
        endDate =
            DateTime.tryParse(other[_JsonFields.endDate] as String? ?? ''),
        isLocked = other[_JsonFields.isLocked] as bool,
        super.from();

  @override
  Map<String, dynamic> toJson() => {
        ...super.toJson(),
        _JsonFields.description: description,
        _JsonFields.startDate: startDate?.toUtc().toIso8601String(),
        _JsonFields.endDate: endDate?.toUtc().toIso8601String(),
        _JsonFields.isLocked: isLocked,
      };

  /// Date only part of [startDate].
  DateTime? get dateOnly => startDate?.dateOnly;

  TimeOfDay get startTime => TimeOfDay.fromDateTime(startDate!.toLocal());

  TimeOfDay get endTime => TimeOfDay.fromDateTime(endDate!.toLocal());

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
      '${DateFormat.yMd().format(dateOnly!)} $timeRange';

  bool isOn(DateTime dateTime) => dateOnly?.isSameDateAs(dateTime) ?? false;

  bool isBetween(DateRanger dateRange) => dateRange.includes(startDate!);

  bool collidesWith(Booking booking) =>
      startDate!.isBefore(booking.endDate!) &&
      endDate!.isAfter(booking.startDate!);

  @override
  Booking copyWith({
    String? id,
    String? description,
    DateTime? startDate,
    DateTime? endDate,
    bool? isLocked,
    String? cabinId,
  });

  @override
  void replaceWith(covariant Booking item) {
    description = item.description;
    startDate = item.startDate;
    endDate = item.endDate;
    isLocked = item.isLocked;

    super.replaceWith(item);
  }

  @override
  String toString() =>
      [if (isLocked) '🔒', description, dateTimeRange].join(' ');

  @override
  int compareTo(covariant Booking other) =>
      startDate!.compareTo(other.startDate!);
}
