import 'package:cabin_booking/utils/date_time_extension.dart';
import 'package:cabin_booking/utils/time_of_day_extension.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

typedef DateFormatter = DateFormat Function(DateFormat);

/// Adds date range operations between a [startDate] and an [endDate].
mixin DateRanger {
  /// The start [DateTime] of this [DateRanger].
  ///
  /// If null, represents a [DateRanger] including all dates up to [endDate].
  DateTime? get startDate;

  /// The start [DateTime] of this [DateRanger].
  ///
  /// If null, it represents a [DateRanger] including all dates starting from
  /// [startDate].
  DateTime? get endDate;

  /// The time this [DateRanger] starts.
  TimeOfDay? get startTime =>
      hasInfiniteStart ? null : TimeOfDay.fromDateTime(startDate!.toLocal());

  /// The time this [DateRanger] ends.
  TimeOfDay? get endTime =>
      hasInfiniteEnd ? null : TimeOfDay.fromDateTime(endDate!.toLocal());

  /// Whether this [DateRanger] happens on [dateTime], ignoring the time part.
  ///
  /// Example:
  /// ```dart
  /// final dateTime = DateTime(2022, 12, 4);
  /// final dateRange = DateRange(
  ///   startDate: DateTime(2022, 12, 4, 9, 45),
  ///   endDate: DateTime(2022, 12, 4, 21, 15),
  /// );
  /// assert(dateRange.isOn(dateTime));
  /// ```
  bool isOn(DateTime dateTime) {
    if (includes(dateTime)) return true;
    if (!hasInfiniteStart) return dateTime.isSameDateAs(startDate!);
    if (!hasInfiniteEnd) dateTime.isSameDateAs(endDate!);

    return false;
  }

  /// Whether [dateTime] is included in this [DateRanger], including the
  /// [startDate] but excluding the [endDate] instant: `[startDate, endDate)`.
  ///
  /// Examples:
  /// ```dart
  /// assert(DateRange.today().includes(DateTime.now()));
  /// assert(DateRange.infinite.includes(DateTime.now()));
  /// ```
  bool includes(DateTime dateTime) {
    if (hasInfiniteStart && hasInfiniteEnd) return true;
    if (hasInfiniteStart) return endDate!.isAfter(dateTime);
    if (hasInfiniteEnd) {
      return startDate!.isAtSameMomentAs(dateTime) ||
          startDate!.isBefore(dateTime);
    }

    return (startDate!.isAtSameMomentAs(dateTime) ||
            startDate!.isBefore(dateTime)) &&
        endDate!.isAfter(dateTime);
  }

  /// Whether this [DateRanger] overlaps with another [DateRanger].
  ///
  /// Example:
  /// ```dart
  /// final dateRange1 = DateRange(
  ///   startDate: DateTime(2022, 12, 4),
  ///   endDate: DateTime(2022, 12, 6),
  /// );
  /// final dateRange2 = DateRange(
  ///   startDate: DateTime(2022, 12, 5),
  ///   endDate: DateTime(2022, 12, 7),
  /// );
  /// assert(dateRange1.overlapsWith(dateRange2));
  /// assert(DateRange.infinite.overlapsWith(dateRange1));
  /// ```
  bool overlapsWith(DateRanger other) {
    if (hasInfiniteStart && hasInfiniteEnd ||
        other.hasInfiniteStart && other.hasInfiniteEnd) return true;
    if (hasInfiniteStart && !other.hasInfiniteStart) {
      return endDate!.isAfter(other.startDate!);
    }
    if (hasInfiniteEnd && !other.hasInfiniteEnd) {
      return startDate!.isBefore(other.endDate!);
    }

    return startDate!.isBefore(other.endDate!) &&
        endDate!.isAfter(other.startDate!);
  }

  /// Whether this [DateRanger] has [startDate] and [endDate] values.
  ///
  /// Examples:
  /// ```dart
  /// assert(DateRange.today().isFinite);
  /// assert(!DateRange().isFinite);
  /// ```
  bool get isFinite => startDate != null && endDate != null;

  /// Whether this [DateRanger] has no [startDate] nor [endDate] values.
  ///
  /// Examples:
  /// ```dart
  /// assert(DateRange().isInfinite);
  /// assert(DateRange(startDate: DateTime.now()).isInfinite);
  /// assert(DateRange(endDate: DateTime.now()).isInfinite);
  /// assert(!DateRange.today().isInfinite);
  /// ```
  bool get isInfinite => hasInfiniteStart || hasInfiniteEnd;

  /// Whether this [DateRanger] has [endDate] but no [startDate].
  ///
  /// Example:
  /// ```dart
  /// assert(DateRange(endDate: DateTime.now()).hasInfiniteStart);
  /// assert(DateRange.infinite.hasInfiniteStart);
  /// ```
  bool get hasInfiniteStart => startDate == null;

  /// Whether this [DateRanger] has [startDate] but no [endDate].
  ///
  /// Example:
  /// ```dart
  /// assert(DateRange(startDate: DateTime.now()).hasInfiniteEnd);
  /// assert(DateRange.infinite.hasInfiniteEnd);
  /// ```
  bool get hasInfiniteEnd => endDate == null;

  /// The [Duration] of this [DateRanger].
  ///
  /// If this [DateRanger.isInfinite], returns [Duration.zero].
  ///
  /// Examples:
  /// ```dart
  /// const oneDay = Duration(days: 1);
  /// assert(DateRange.today().duration == oneDay);
  /// assert(DateRange.infinite.duration == Duration.zero);
  /// ```
  Duration get duration {
    if (isInfinite) return Duration.zero;

    return endDate!.difference(startDate!);
  }

  /// Returns the formatted local date and time range of this [DateRanger].
  ///
  /// By default, [referenceDateTime] is set to [DateTime.now()] to whether
  /// show or hide the matching year.
  ///
  /// Example:
  /// ```dart
  /// final dateRange = DateRange(
  ///   startDate: DateTime(2022, 12, 1, 9, 30),
  ///   endDate: DateTime(2022, 12, 1, 21, 30),
  /// );
  /// final textualDateTime = dateRange.textualDateTime(
  ///   referenceDateTime: DateTime(2022),
  /// );
  /// assert(textualDateTime == '1 December 9:30–21:30');
  /// ```
  ///
  /// Date format may also be overridden as desired:
  ///
  /// ```dart
  /// final dateRange = DateRange(
  ///   startDate: DateTime(2022, 12, 1, 9, 30),
  ///   endDate: DateTime(2022, 12, 31, 21, 30),
  /// );
  /// final formatted = dateRange.textualDateTime(
  ///   referenceDateTime: DateTime(2023),
  ///   fullDateFormat: (format) => format.add_yMMMEd(),
  ///   monthDayFormat: (format) => format.add_LLL().add_d(),
  ///   timeFormat: (format) => format.add_Hms(),
  /// );
  /// assert(formatted == 'Thu, Dec 1, 2022 09:30:00 – Dec 31 21:30:00');
  /// ```
  String textualDateTime({
    DateTime? referenceDateTime,
    DateFormatter? timeFormat,
    DateFormatter? monthDayFormat,
    DateFormatter? fullDateFormat,
  }) {
    if (hasInfiniteStart && hasInfiniteEnd) return _formatTextualDateTime();

    timeFormat ??= (format) => format.add_Hm();
    fullDateFormat ??= (format) => format.add_yMMMMd();
    final formatFull = timeFormat(fullDateFormat(DateFormat()));

    if (startDate?.year != endDate?.year) {
      return _formatTextualDateTime(start: formatFull, end: formatFull);
    }

    referenceDateTime ??= DateTime.now();
    monthDayFormat ??= (format) => format.add_MMMMd();
    final formatNoYear = timeFormat(monthDayFormat(DateFormat()));
    final formatTimeOnly = timeFormat(DateFormat());

    return _formatTextualDateTime(
      start:
          startDate?.year == referenceDateTime.year ? formatNoYear : formatFull,
      end: startDate!.isSameDateAs(endDate!) ? formatTimeOnly : formatNoYear,
    );
  }

  String _formatTextualDateTime({
    DateFormat? start,
    DateFormat? end,
    String separator = '–',
  }) {
    final formattedStartDate = _formatLocalDateTime(startDate, start);
    final formattedEndDate = _formatLocalDateTime(endDate, end);
    final shouldWhitespace = formattedStartDate == null ||
        (formattedEndDate?.contains(RegExp(r'\s')) ?? true);

    return '$formattedStartDate'
        '${shouldWhitespace ? ' $separator ' : separator}'
        '$formattedEndDate';
  }

  String? _formatLocalDateTime(DateTime? dateTime, DateFormat? dateFormat) =>
      dateTime != null ? dateFormat?.format(dateTime.toLocal()) : null;

  /// Returns the formatted local time range of this [DateRanger].
  ///
  /// Example:
  /// ```dart
  /// final dateRange = DateRange(
  ///   startDate: DateTime(2022, 12, 1, 9, 30),
  ///   endDate: DateTime(2022, 12, 1, 21, 30),
  /// );
  /// assert(dateRange.timeRange == '9:30–21:30');
  /// ```
  String get textualTime => textualDateTime(
        monthDayFormat: (format) => format,
        fullDateFormat: (format) => format,
      );

  /// The time span of this [DateRanger] in hours.
  ///
  /// Example:
  /// ```dart
  /// final dateRange = DateRange(
  ///   startDate: DateTime(2022, 12, 4, 9, 30),
  ///   endDate: DateTime(2022, 12, 4, 13, 15),
  /// );
  /// final hoursSpan = {
  ///   const TimeOfDay(hour: 09, minute: 0): const Duration(minutes: 30),
  ///   const TimeOfDay(hour: 10, minute: 0): const Duration(hours: 1),
  ///   const TimeOfDay(hour: 11, minute: 0): const Duration(hours: 1),
  ///   const TimeOfDay(hour: 12, minute: 0): const Duration(hours: 1),
  ///   const TimeOfDay(hour: 13, minute: 0): const Duration(minutes: 15),
  /// };
  /// assert(dateRange.hoursSpan == hoursSpan);
  /// ```
  Map<TimeOfDay, Duration> get hoursSpan {
    final timeRanges = <TimeOfDay, Duration>{};

    if (isInfinite) return timeRanges;

    var runTime = startTime!;
    var runDuration = Duration.zero;

    while (runDuration < duration) {
      final nextHour = runTime.increment(hours: 1).replacing(minute: 0);

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

  /// Returns a list of [DateTime]s between [start] and [end] every [interval].
  ///
  /// Used in [DateRanger.dateTimeList].
  static List<DateTime> _rangeDateTimeList(
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

  /// Returns a list of [DateTime]s included in this [DateRanger]
  /// every [interval].
  ///
  /// If this [DateRanger.isInfinite], returns an empty list.
  ///
  /// Example:
  /// ```dart
  /// const interval = Duration(hours: 8);
  /// final dateRange = DateRange.fromDate(DateTime(2022, 12, 4));
  /// final dates = [
  ///   DateTime(2022, 12, 4),
  ///   DateTime(2022, 12, 4, 8),
  ///   DateTime(2022, 12, 4, 16),
  ///   DateTime(2022, 12, 5),
  /// ];
  /// assert(dateRange.dateTimeList(interval: interval) == dates);
  /// ```
  List<DateTime> dateTimeList({Duration interval = const Duration(days: 1)}) {
    if (isInfinite) return const <DateTime>[];

    return _rangeDateTimeList(startDate!, endDate!, interval: interval);
  }
}
