import 'package:cabin_booking/utils/date_time_extension.dart';

import '../cabin/cabin.dart';
import '../date/date_range_item.dart';

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

  /// The reference of the booked [Cabin].
  Cabin? cabin;

  /// Creates a new [Booking].
  Booking({
    super.id,
    super.startDate,
    super.endDate,
    this.description,
    this.isLocked = false,
    this.cabin,
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

  @override
  Booking copyWith({
    String? id,
    DateTime? startDate,
    DateTime? endDate,
    String? description,
    bool? isLocked,
    Cabin? cabin,
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
  String toString() => [
        if (isLocked) '🔒',
        description,
        // A reference DateTime with year 0 will always show the year textually.
        textualDateTime(referenceDateTime: DateTime(0)),
      ].join(' ');

  @override
  bool operator ==(Object other) =>
      super == other &&
      other is Booking &&
      description == other.description &&
      isLocked == other.isLocked;

  @override
  int get hashCode => Object.hash(super.hashCode, description, isLocked);
}
