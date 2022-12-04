/// Adds date range operations between a [startDate] and an [endDate].
mixin DateRanger {
  /// The start [DateTime] of this [DateRanger].
  ///
  /// If null, represents a [DateRanger] including all dates up to [endDate].
  DateTime? get startDate;

  /// The start [DateTime] of this [DateRanger].
  ///
  /// If null, represents a [DateRanger] including all dates starting from
  /// [startDate].
  DateTime? get endDate;

  /// Whether [dateTime] is included in this [DateRanger].
  ///
  /// Examples:
  /// ```dart
  /// assert(DateRange.today().includes(DateTime.now()));
  /// assert(DateRange.infinite.includes(DateTime.now()));
  /// ```
  bool includes(DateTime dateTime) {
    if (hasInfiniteStart && hasInfiniteEnd) return true;
    if (hasInfiniteStart) return endDate!.isAfter(dateTime);
    if (hasInfiniteEnd) return startDate!.isBefore(dateTime);

    return startDate!.isBefore(dateTime) && endDate!.isAfter(dateTime);
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
  /// final dateRange = DateRange.from(DateTime(2022, 12, 4));
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
