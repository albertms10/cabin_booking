import 'package:collection/collection.dart' show IterableExtension;

import '../cabin/cabin.dart';
import 'booking.dart';
import 'single_booking.dart';

abstract class _JsonFields {
  static const periodicity = 'p';
  static const repeatEvery = 're';
  static const recurringEndDate = 'red';
  static const occurrences = 'o';
}

/// A recurring booking item.
class RecurringBooking extends Booking {
  Periodicity periodicity;
  int repeatEvery;

  DateTime? _recurringEndDate;
  int? _occurrences;

  RecurringBooking({
    super.id,
    super.startDate,
    super.endDate,
    super.description,
    super.isLocked,
    super.cabin,
    this.periodicity = Periodicity.weekly,
    this.repeatEvery = 1,
    DateTime? recurringEndDate,
    int? occurrences,
  })  : assert(
          (recurringEndDate == null) != (occurrences == null),
          'Either recurringEndDate or occurrences must be given, '
          'but not both.',
        ),
        _recurringEndDate = recurringEndDate,
        _occurrences = occurrences;

  RecurringBooking.fromJson(super.other)
      : periodicity = Periodicity.values[other[_JsonFields.periodicity] as int],
        repeatEvery = other[_JsonFields.repeatEvery] as int,
        _recurringEndDate = other.containsKey(_JsonFields.recurringEndDate)
            ? DateTime.tryParse(other[_JsonFields.recurringEndDate] as String)
            : null,
        _occurrences = other.containsKey(_JsonFields.occurrences)
            ? other[_JsonFields.occurrences] as int?
            : null,
        super.fromJson();

  factory RecurringBooking.fromBooking(
    Booking booking, {
    Periodicity? periodicity,
    int? repeatEvery,
    DateTime? recurringEndDate,
    int? occurrences,
  }) {
    if (booking is RecurringBooking) {
      return booking.copyWith(
        periodicity: periodicity,
        repeatEvery: repeatEvery,
        recurringEndDate: recurringEndDate,
        occurrences: occurrences,
      );
    } else {
      periodicity ??= Periodicity.weekly;
      repeatEvery ??= 1;
    }
    assert(
      (recurringEndDate == null) != (occurrences == null),
      'Either recurringEndDate or occurrences must be given, '
      'but not both.',
    );

    return RecurringBooking(
      id: booking.id,
      startDate: booking.startDate,
      endDate: booking.endDate,
      description: booking.description,
      isLocked: booking.isLocked,
      cabin: booking.cabin,
      periodicity: periodicity,
      repeatEvery: repeatEvery,
      recurringEndDate: recurringEndDate,
      occurrences: occurrences,
    );
  }

  /// Override getter from [Booking] to prevent a circular reference to this
  /// [RecurringBooking] at instantiation.
  @override
  RecurringBooking get recurringBooking => this;

  static bool isRecurringBooking(Booking? booking) =>
      booking is RecurringBooking || booking!.recurringBooking?.id != null;

  @override
  Map<String, dynamic> toJson() => {
        ...super.toJson(),
        _JsonFields.periodicity: periodicity.index,
        _JsonFields.repeatEvery: repeatEvery,
        if (method == RecurringBookingMethod.endDate)
          _JsonFields.recurringEndDate:
              _recurringEndDate?.toUtc().toIso8601String()
        else if (method == RecurringBookingMethod.occurrences)
          _JsonFields.occurrences: _occurrences,
      };

  RecurringBookingMethod get method => _recurringEndDate != null
      ? RecurringBookingMethod.endDate
      : RecurringBookingMethod.occurrences;

  Duration get periodicityDuration =>
      Duration(days: periodicity.days * repeatEvery);

  DateTime get recurringEndDate {
    if (_recurringEndDate != null) return _recurringEndDate!;

    assert(_occurrences != null, '_occurrences must be non-null.');

    return dateOnly!.add(periodicityDuration * _occurrences!);
  }

  set recurringEndDate(DateTime date) {
    _recurringEndDate = date;
    _occurrences = null;
  }

  int get occurrences {
    if (_occurrences != null) return _occurrences!;

    assert(_recurringEndDate != null, '_recurringEndDate must be non-null.');

    var count = 0;
    var runDate = startDate!;

    while (runDate.isBefore(_recurringEndDate!)) {
      runDate = runDate.add(periodicityDuration);
      count++;
    }

    return count;
  }

  set occurrences(int occurrences) {
    _occurrences = occurrences;
    _recurringEndDate = null;
  }

  SingleBooking asSingleBooking({bool linked = true}) => SingleBooking(
        id: linked ? '$id-0' : id,
        startDate: startDate,
        endDate: endDate,
        description: description,
        isLocked: isLocked,
        cabin: cabin,
        recurringBooking: linked ? this : null,
      );

  List<SingleBooking> get bookings {
    final runBookings = <SingleBooking>[];
    var runDate = startDate!;
    var movedBooking = asSingleBooking();

    var count = 1;

    while (runDate.isBefore(recurringEndDate)) {
      runBookings.add(
        movedBooking
          ..id = '$id-$count'
          ..recurringBooking = this
          ..recurringNumber = count,
      );

      runDate = runDate.add(periodicityDuration);

      if (runDate.isBefore(recurringEndDate)) {
        movedBooking = movedBooking.copyWith(
          startDate: runDate,
          endDate: runDate.add(duration),
        );
        count++;
      }
    }

    return runBookings;
  }

  SingleBooking? bookingOn(DateTime dateTime) => bookings.firstWhereOrNull(
        (booking) => booking.isOn(dateTime),
      );

  bool hasBookingOn(DateTime dateTime) => bookingOn(dateTime) != null;

  @override
  RecurringBooking copyWith({
    String? id,
    DateTime? startDate,
    DateTime? endDate,
    String? description,
    bool? isLocked,
    Cabin? cabin,
    Periodicity? periodicity,
    int? repeatEvery,
    DateTime? recurringEndDate,
    int? occurrences,
  }) =>
      RecurringBooking(
        id: id ?? this.id,
        startDate: startDate ?? this.startDate,
        endDate: endDate ?? this.endDate,
        description: description ?? this.description,
        isLocked: isLocked ?? this.isLocked,
        cabin: cabin ?? this.cabin,
        periodicity: periodicity ?? this.periodicity,
        repeatEvery: repeatEvery ?? this.repeatEvery,
        recurringEndDate: recurringEndDate ??
            (occurrences != null ? null : _recurringEndDate),
        occurrences:
            occurrences ?? (recurringEndDate != null ? null : _occurrences),
      );

  @override
  void replaceWith(covariant RecurringBooking item) {
    periodicity = item.periodicity;
    _recurringEndDate = item._recurringEndDate;
    _occurrences = item._occurrences;

    super.replaceWith(item);
  }

  @override
  String toString() => '$occurrences × ${super.toString()}';

  @override
  bool operator ==(Object other) =>
      super == other &&
      other is RecurringBooking &&
      periodicity == other.periodicity &&
      repeatEvery == other.repeatEvery &&
      _recurringEndDate == other._recurringEndDate &&
      _occurrences == other._occurrences;

  @override
  int get hashCode => Object.hash(
        super.hashCode,
        periodicity,
        repeatEvery,
        _recurringEndDate,
        _occurrences,
      );
}

enum Periodicity {
  daily(days: 1),
  weekly(days: 7),
  monthly(days: 30),
  annually(days: 365);

  const Periodicity({required this.days});

  final int days;
}

enum RecurringBookingMethod { endDate, occurrences }
