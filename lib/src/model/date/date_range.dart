import 'package:cabin_booking/utils/date_time_extension.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'date_ranger.dart';

/// A representation of the range between two [DateTime] objects.
@immutable
class DateRange with DateRanger {
  @override
  final DateTime? startDate;

  @override
  final DateTime? endDate;

  /// Creates a new [DateRange] from [startDate] and [endDate].
  const DateRange({this.startDate, this.endDate});

  /// A [DateRange] with no start nor end dates, representing a range that
  /// includes all possible dates.
  static const infinite = DateRange();

  /// Creates a copy of this [DateRange] but with the given fields replaced
  /// with the new values.
  DateRange copyWith({DateTime? startDate, DateTime? endDate}) => DateRange(
        startDate: startDate ?? this.startDate,
        endDate: endDate ?? this.endDate,
      );

  /// Creates a new [DateRange] that lasts the whole [dateTime].
  ///
  /// Example:
  /// ```dart
  /// final dateTime = DateTime(2022, 12, 4, 19, 30);
  /// final dateRange = DateRange.from(dateTime);
  /// assert(dateRange.startDate == DateTime(2022, 12, 4));
  /// assert(dateRange.endDate == DateTime(2022, 12, 5));
  /// ```
  factory DateRange.from(DateTime dateTime) {
    final startDateOnly = dateTime.dateOnly;

    return DateRange(
      startDate: startDateOnly,
      endDate: startDateOnly.add(const Duration(days: 1)),
    );
  }

  /// Creates a new [DateRange] that lasts the whole day of today.
  factory DateRange.today() => DateRange.from(DateTime.now());

  @override
  String toString() => '${DateFormat.yMd().format(startDate!)}'
      ' - ${DateFormat.yMd().format(endDate!)}';

  @override
  bool operator ==(Object other) =>
      other is DateRange &&
      startDate == other.startDate &&
      endDate == other.endDate;

  @override
  int get hashCode => Object.hash(startDate, endDate);
}
