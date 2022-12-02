import 'package:collection/collection.dart' show IterableExtension;

import 'booking.dart';
import 'single_booking.dart';

abstract class _JsonFields {
  static const periodicity = 'p';
  static const repeatEvery = 're';
  static const recurringEndDate = 'edt';
  static const occurrences = 'o';
}

class RecurringBooking extends Booking {
  Periodicity periodicity;
  int repeatEvery;

  DateTime? _recurringEndDate;
  int? _occurrences;

  RecurringBooking({
    super.id,
    super.description,
    super.startDateTime,
    super.endDateTime,
    super.isLocked,
    super.cabinId,
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

  RecurringBooking.from(super.other)
      : periodicity = Periodicity.values[other[_JsonFields.periodicity] as int],
        repeatEvery = other[_JsonFields.repeatEvery] as int,
        _recurringEndDate = other.containsKey(_JsonFields.recurringEndDate)
            ? DateTime.tryParse(other[_JsonFields.recurringEndDate] as String)
            : null,
        _occurrences = other.containsKey(_JsonFields.occurrences)
            ? other[_JsonFields.occurrences] as int?
            : null,
        super.from();

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
      description: booking.description,
      startDateTime: booking.startDateTime,
      endDateTime: booking.endDateTime,
      isLocked: booking.isLocked,
      cabinId: booking.cabinId,
      periodicity: periodicity,
      repeatEvery: repeatEvery,
      recurringEndDate: recurringEndDate,
      occurrences: occurrences,
    );
  }

  static bool isRecurringBooking(Booking? booking) =>
      booking is RecurringBooking || booking!.recurringBookingId != null;

  @override
  Map<String, dynamic> toJson() => {
        ...super.toJson(),
        _JsonFields.periodicity: periodicity.index,
        _JsonFields.repeatEvery: repeatEvery,
        if (method == RecurringBookingMethod.endDate)
          _JsonFields.recurringEndDate:
              _recurringEndDate?.toIso8601String().split('T').first
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

    return date!.add(periodicityDuration * _occurrences!);
  }

  set recurringEndDate(DateTime date) {
    _recurringEndDate = date;
    _occurrences = null;
  }

  int get occurrences {
    if (_occurrences != null) return _occurrences!;

    assert(_recurringEndDate != null, '_recurringEndDate must be non-null.');

    var count = 0;
    var runDate = date!;

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
        id: linked ? '$id-0' : (recurringBookingId ?? id),
        description: description,
        startDateTime: startDateTime,
        endDateTime: endDateTime,
        isLocked: isLocked,
        cabinId: cabinId,
        recurringBookingId: linked ? id : null,
      );

  List<SingleBooking> get bookings {
    final runBookings = <SingleBooking>[];
    var runDate = date!;
    var movedBooking = asSingleBooking();

    var count = 1;

    while (runDate.isBefore(recurringEndDate)) {
      runBookings.add(
        movedBooking
          ..id = '$id-$count'
          ..recurringBookingId = id
          ..recurringNumber = count
          ..recurringTotalTimes = occurrences,
      );

      runDate = runDate.add(periodicityDuration);

      if (runDate.isBefore(recurringEndDate)) {
        movedBooking = movedBooking.copyWith(
          startDateTime: runDate,
          endDateTime: runDate.add(duration),
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
    String? description,
    DateTime? startDateTime,
    DateTime? endDateTime,
    bool? isLocked,
    String? cabinId,
    Periodicity? periodicity,
    int? repeatEvery,
    DateTime? recurringEndDate,
    int? occurrences,
  }) =>
      RecurringBooking(
        id: id ?? this.id,
        description: description ?? this.description,
        startDateTime: startDateTime ?? this.startDateTime,
        endDateTime: endDateTime ?? this.endDateTime,
        isLocked: isLocked ?? this.isLocked,
        cabinId: cabinId ?? this.cabinId,
        periodicity: periodicity ?? this.periodicity,
        repeatEvery: repeatEvery ?? this.repeatEvery,
        recurringEndDate: recurringEndDate != null && occurrences == null
            ? recurringEndDate
            : _recurringEndDate,
        occurrences: occurrences != null && recurringEndDate == null
            ? occurrences
            : _occurrences,
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
