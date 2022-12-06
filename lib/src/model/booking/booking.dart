import 'package:cabin_booking/utils/date_time_extension.dart';
import 'package:cabin_booking/utils/time_of_day_extension.dart';
import 'package:intl/intl.dart';

import '../date/date_ranger.dart';
import '../item.dart';

abstract class _JsonFields {
  static const description = 'de';
  static const startDate = 'sd';
  static const endDate = 'ed';
  static const isLocked = 'il';
}

/// A booking item.
abstract class Booking extends Item with DateRanger {
  /// The description used to visually identify this [Booking].
  String? description;

  @override
  DateTime? startDate;

  @override
  DateTime? endDate;

  /// Whether this [Booking] represents a locked time slot.
  bool isLocked;

  /// The ID of the booked Cabin.
  String? cabinId;

  /// The ID of the recurring booking, if this [Booking] is part of a series of
  /// recurring bookings.
  String? recurringBookingId;

  /// The occurrence number this [Booking] appears in the list of recurring
  /// bookings. E.g., the 2nd occurrence out of 5.
  int? recurringNumber;

  /// The total times the recurring booking occurs.
  int? recurringTotalTimes;

  /// Creates a new [Booking].
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

  /// Creates a new [Booking] from a JSON Map.
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

  String get timeRange => '${startTime!.format24Hour()}'
      '–${endTime!.format24Hour()}';

  String get dateTimeRange =>
      '${DateFormat.yMd().format(dateOnly!)} $timeRange';

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
