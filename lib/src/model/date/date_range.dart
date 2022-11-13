import 'package:intl/intl.dart';

class DateRange with DateRanger {
  @override
  DateTime? startDate;

  @override
  DateTime? endDate;

  DateRange({this.startDate, DateTime? endDate}) {
    if (startDate != null && endDate != null && !endDate.isBefore(startDate!)) {
      this.endDate = endDate;
    }
  }

  DateRange copyWith({
    DateTime? startDate,
    DateTime? endDate,
  }) =>
      DateRange(
        startDate: startDate ?? this.startDate,
        endDate: endDate ?? this.endDate,
      );

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

mixin DateRanger {
  DateTime? get startDate;
  DateTime? get endDate;

  bool includes(DateTime dateTime) =>
      startDate!.isBefore(dateTime) && endDate!.isAfter(dateTime);

  Duration get duration => endDate!.difference(startDate!);

  static List<DateTime> rangeDateTimeList(
    DateTime start,
    DateTime end, {
    Duration interval = const Duration(days: 1),
  }) {
    assert(end.isAfter(start), 'end must be after start.');

    final dates = [start];
    var runDate = start;

    while (runDate.isBefore(end)) {
      runDate = runDate.add(interval);
      dates.add(runDate);
    }

    return dates;
  }

  List<DateTime> dateTimeList({Duration interval = const Duration(days: 1)}) =>
      rangeDateTimeList(startDate!, endDate!, interval: interval);
}
