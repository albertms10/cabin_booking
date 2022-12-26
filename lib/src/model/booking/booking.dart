import 'package:cabin_booking/utils/date_time_extension.dart';
import 'package:cabin_booking/utils/time_of_day_extension.dart';
import 'package:intl/intl.dart';

import '../date/date_range_item.dart';
import 'recurring_booking.dart';

abstract class _JsonFields {
  static const description = 'de';
  static const isLocked = 'il';
}

/// A booking item.
abstract class Booking extends DateRangeItem {
  /// The description used to visually identify this [Booking].
  String? description;

  /// Whether this [Booking] represents a locked time slot.
  bool isLocked;

  /// The ID of the booked Cabin.
  String? cabinId;

  /// The [RecurringBooking] reference, if this [Booking] is part of a series of
  /// recurring bookings.
  RecurringBooking? recurringBooking;

  /// The occurrence number this [Booking] appears in the list of recurring
  /// bookings. E.g., the 2nd occurrence out of 5.
  int? recurringNumber;

  /// Creates a new [Booking].
  Booking({
    super.id,
    super.startDate,
    super.endDate,
    this.description,
    this.isLocked = false,
    this.cabinId,
    this.recurringBooking,
    this.recurringNumber,
  });

  /// Creates a new [Booking] from a JSON Map.
  Booking.fromJson(super.other)
      : description = other[_JsonFields.description] as String?,
        isLocked = other[_JsonFields.isLocked] as bool,
        super.fromJson();

  @override
  Map<String, dynamic> toJson() => {
        ...super.toJson(),
        _JsonFields.description: description,
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
    DateTime? startDate,
    DateTime? endDate,
    String? description,
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
  bool operator ==(Object other) =>
      super == other &&
      other is Booking &&
      description == other.description &&
      isLocked == other.isLocked;

  @override
  int get hashCode => Object.hash(super.hashCode, description, isLocked);
}
