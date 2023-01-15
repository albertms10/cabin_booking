import 'dart:collection' show SplayTreeSet;

import '../date/date_range_item.dart';
import '../date/holiday.dart';

abstract class _JsonFields {
  static const holidays = 'h';
}

class SchoolYear extends DateRangeItem {
  final Set<Holiday> holidays;

  SchoolYear({
    super.id,
    super.startDate,
    super.endDate,
    Set<Holiday>? holidays,
  }) : holidays = holidays ?? SplayTreeSet();

  SchoolYear.fromJson(super.other)
      : holidays = SplayTreeSet.of(
          (other[_JsonFields.holidays] as List<dynamic>)
              .cast<Map<String, dynamic>>()
              .map<Holiday>(Holiday.fromJson),
        ),
        super.fromJson();

  @override
  Map<String, dynamic> toJson() => {
        ...super.toJson(),
        _JsonFields.holidays:
            holidays.map((holiday) => holiday.toJson()).toList(),
      };

  Duration get holidaysDuration {
    var duration = Duration.zero;

    for (final holiday in holidays) {
      duration += holiday.duration;
    }

    return duration;
  }

  Duration get workingDuration => duration - holidaysDuration;

  bool isOnHolidays(DateTime dateTime) {
    for (final holiday in holidays) {
      if (holiday.includes(dateTime)) return true;
    }

    return false;
  }

  @override
  void replaceWith(covariant SchoolYear item) {
    startDate = item.startDate;
    endDate = item.endDate;

    super.replaceWith(item);
  }

  @override
  String toString() => textualDateTime(
        referenceDateTime: DateTime(0),
        fullDateFormat: (format) => format.add_y(),
        monthDayFormat: (format) => format.add_y(),
        timeFormat: (format) => format,
      );
}
