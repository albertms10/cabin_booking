import 'package:cabin_booking/constants.dart';
import 'package:cabin_booking/utils/app_localizations_extension.dart';
import 'package:cabin_booking/utils/date_time_extension.dart';
import 'package:cabin_booking/utils/iterable_string_extension.dart';
import 'package:cabin_booking/utils/time_of_day_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
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
    super.id,
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
  });

  Booking.from(super.other)
      : description = other[_JsonFields.description] as String?,
        date = DateTime.tryParse(other[_JsonFields.date] as String),
        startTime =
            TimeOfDayExtension.tryParse(other[_JsonFields.startTime] as String),
        endTime =
            TimeOfDayExtension.tryParse(other[_JsonFields.endTime] as String),
        status = BookingStatus.values[other[_JsonFields.status] as int],
        isLocked = other[_JsonFields.isLocked] as bool,
        super.from();

  @override
  Map<String, dynamic> toJson() => {
        ...super.toJson(),
        _JsonFields.description: description,
        _JsonFields.date: date?.toIso8601String().split('T').first,
        _JsonFields.startTime: startTime?.format24Hour(),
        _JsonFields.endTime: endTime?.format24Hour(),
        _JsonFields.status: status.index,
        _JsonFields.isLocked: isLocked,
      };

  DateTime get startDateTime => date!.addTimeOfDay(startTime);

  DateTime get endDateTime => date!.addTimeOfDay(endTime);

  Duration get duration => endDateTime.difference(startDateTime);

  Map<TimeOfDay, Duration> get hoursSpan {
    final timeRanges = <TimeOfDay, Duration>{};

    var runTime = startTime!;
    var runDuration = Duration.zero;

    while (runDuration < duration) {
      final nextHour = TimeOfDay(
        hour: (runTime.hour + 1) % TimeOfDay.hoursPerDay,
        minute: 0,
      );

      final nextTime =
          endTime!.difference(nextHour).isNegative ? endTime! : nextHour;
      final currentDuration = nextTime.difference(runTime);

      runDuration += currentDuration;

      timeRanges.addAll({
        runTime.replacing(minute: 0): currentDuration,
      });

      runTime = nextTime;
    }

    return timeRanges;
  }

  String get timeRange => '${startTime?.format24Hour()}'
      '–${endTime?.format24Hour()}';

  String get dateTimeRange => '${DateFormat.yMd().format(date!)} $timeRange';

  bool isOn(DateTime dateTime) => date?.isSameDateAs(dateTime) ?? false;

  bool isBetween(DateRanger dateRange) => dateRange.includes(startDateTime);

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

  static List<RegExp> tokenExpressions(AppLocalizations appLocalizations) => [
        RegExp('(?<startTime>$timeExpression)'),
        RegExp(
          '(?<startTime>$timeExpression)(?:.*?)(?<endTime>$timeExpression)',
          dotAll: true,
        ),
        RegExp(
          r'(?<durationValue1>\d+)\W*'
          '(?<durationUnit1>${appLocalizations.timeUnits.union})',
        ),
        RegExp(
          r'(?<durationValue1>\d+)\W*'
          '(?<durationUnit1>${appLocalizations.timeUnits.union})'
          r'(:?.*?)(?<durationValue2>\d+)\W*'
          '(?<durationUnit2>${appLocalizations.timeUnits.union})',
          dotAll: true,
        ),
        RegExp(
          '(?<relativeDay>${appLocalizations.relativeDays.union})',
          caseSensitive: false,
        ),
        // DateTime.
      ];

  factory Booking.fromTokens(
    Map<String, String?> tokens,
    AppLocalizations appLocalizations,
  ) {
    final durationValue1 = int.tryParse(tokens['durationValue1'] ?? '');

    final duration1 =
        appLocalizations.minuteUnits.contains(tokens['durationUnit1'])
            ? Duration(minutes: durationValue1 ?? 0)
            : Duration(hours: durationValue1 ?? 0);

    final durationValue2 = int.tryParse(tokens['durationValue2'] ?? '');

    final duration2 =
        appLocalizations.minuteUnits.contains(tokens['durationUnit2'])
            ? Duration(minutes: durationValue2 ?? 0)
            : Duration(hours: durationValue2 ?? 0);

    final startTime = TimeOfDayExtension.tryParse(tokens['startTime'] ?? '');

    var endTime = startTime?.increment(
      minutes: duration1.inMinutes + duration2.inMinutes,
    );

    if (startTime != null && endTime != null) {
      if (endTime.difference(startTime).isNegative) {
        print('negative');
        endTime = const TimeOfDay(hour: 23, minute: 59);
      }
    }

    return Booking(
      date: DateTime.now(),
      startTime: startTime,
      endTime: TimeOfDayExtension.tryParse(tokens['endTime'] ?? '') ?? endTime,
    );
  }
}

enum BookingStatus { pending, confirmed, cancelled }

extension LocalizedBookingStatus on BookingStatus {
  String localized(AppLocalizations appLocalizations) {
    switch (this) {
      case BookingStatus.pending:
        return appLocalizations.pending;
      case BookingStatus.confirmed:
        return appLocalizations.confirmed;
      case BookingStatus.cancelled:
        return appLocalizations.cancelled;
    }
  }
}

extension LayoutBookingStatus on BookingStatus {
  Color color(ThemeData theme) {
    switch (this) {
      case BookingStatus.pending:
        return theme.hintColor;
      case BookingStatus.confirmed:
        return theme.brightness == Brightness.light
            ? Colors.greenAccent[700]!
            : Colors.greenAccent;
      case BookingStatus.cancelled:
        return Colors.redAccent;
    }
  }

  IconData get icon {
    switch (this) {
      case BookingStatus.pending:
        return Icons.help_outline;
      case BookingStatus.confirmed:
        return Icons.check;
      case BookingStatus.cancelled:
        return Icons.clear;
    }
  }
}
