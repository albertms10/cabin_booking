import 'package:intl/intl.dart';

import '../item.dart';
import 'date_range.dart';

abstract class _JsonFields {
  static const startDate = 'sd';
  static const endDate = 'ed';
}

class DateRangeItem extends Item with DateRanger {
  @override
  DateTime? endDate;

  @override
  DateTime? startDate;

  DateRangeItem({
    super.id,
    DateTime? startDate,
    DateTime? endDate,
  }) : assert(
          startDate == null || endDate == null || endDate.isAfter(startDate),
        ) {
    endDate ??= startDate;
  }

  DateRangeItem.from(super.other)
      : startDate = DateTime.tryParse(other[_JsonFields.startDate] as String),
        endDate = DateTime.tryParse(other[_JsonFields.endDate] as String),
        super.from();

  @override
  Map<String, dynamic> toJson() => {
        ...super.toJson(),
        _JsonFields.startDate: startDate?.toIso8601String().split('T').first,
        _JsonFields.endDate: endDate?.toIso8601String().split('T').first,
      };

  @override
  DateRangeItem copyWith({
    DateTime? startDate,
    DateTime? endDate,
  }) =>
      DateRangeItem(
        id: id,
        startDate: startDate ?? this.startDate,
        endDate: endDate ?? this.endDate,
      );

  @override
  String toString() => '${DateFormat.yMd().format(startDate!)}'
      ' - ${DateFormat.yMd().format(endDate!)}';

  @override
  bool operator ==(Object other) =>
      other is DateRangeItem &&
      startDate == other.startDate &&
      endDate == other.endDate;

  @override
  int get hashCode => Object.hash(startDate, endDate);

  @override
  int compareTo(covariant DateRangeItem other) =>
      startDate!.compareTo(other.startDate!);
}
