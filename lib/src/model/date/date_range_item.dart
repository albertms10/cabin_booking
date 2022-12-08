import 'package:intl/intl.dart';

import '../item.dart';
import 'date_ranger.dart';

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
    this.startDate,
    this.endDate,
  }) : assert(
          startDate == null ||
              endDate == null ||
              endDate.isAfter(startDate) ||
              endDate.isAtSameMomentAs(startDate),
          'endDate must be at the same moment or after startDate.',
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
        _JsonFields.startDate: startDate?.toUtc().toIso8601String(),
        _JsonFields.endDate: endDate?.toUtc().toIso8601String(),
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
      super == other &&
      other is DateRangeItem &&
      startDate == other.startDate &&
      endDate == other.endDate;

  @override
  int get hashCode => Object.hash(super.hashCode, startDate, endDate);

  @override
  int compareTo(covariant DateRangeItem other) =>
      startDate!.compareTo(other.startDate!);
}
