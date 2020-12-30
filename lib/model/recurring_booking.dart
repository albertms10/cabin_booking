import 'package:cabin_booking/model/booking.dart';
import 'package:flutter/material.dart';

class RecurringBooking extends Booking {
  Periodicity periodicity;
  int repeatEvery;

  DateTime _endDate;
  int _occurrences;

  RecurringBooking({
    String id,
    String description,
    DateTime date,
    TimeOfDay timeStart,
    TimeOfDay timeEnd,
    bool isDisabled = false,
    String cabinId,
    this.periodicity = Periodicity.Weekly,
    this.repeatEvery = 1,
    DateTime endDate,
    int occurrences,
  })  : assert((endDate == null) != (occurrences == null)),
        _endDate = endDate,
        _occurrences = occurrences,
        super(
          id: id,
          description: description,
          date: date,
          timeStart: timeStart,
          timeEnd: timeEnd,
          isDisabled: isDisabled,
          cabinId: cabinId,
        );

  RecurringBooking.from(Map<String, dynamic> other)
      : periodicity = Periodicity.values[other['periodicityIndex']],
        repeatEvery = other['repeatEvery'],
        _endDate = other.containsKey('endDate')
            ? DateTime.tryParse(other['endDate'])
            : null,
        _occurrences =
            other.containsKey('occurrences') ? other['occurrences'] : null,
        super.from(other);

  RecurringBooking.fromBooking(
    Booking booking, {
    Periodicity periodicity = Periodicity.Weekly,
    int repeatEvery = 1,
  })  : periodicity = periodicity,
        repeatEvery = repeatEvery,
        super(
          id: booking.id,
          description: booking.description,
          date: booking.date,
          timeStart: booking.timeStart,
          timeEnd: booking.timeEnd,
          isDisabled: booking.isDisabled,
          cabinId: booking.cabinId,
        );

  static bool isRecurringBooking(Booking booking) =>
      booking is RecurringBooking || booking.recurringBookingId != null;

  @override
  Map<String, dynamic> toMap() => {
        ...super.toMap(),
        'periodicityIndex': periodicity.index,
        'repeatEvery': repeatEvery,
        if (method == RecurringBookingMethod.EndDate)
          'endDate': _endDate.toIso8601String().split('T').first
        else if (method == RecurringBookingMethod.Occurrences)
          'occurrences': _occurrences,
      };

  @override
  RecurringBooking copyWith({
    String description,
    DateTime date,
    TimeOfDay timeStart,
    TimeOfDay timeEnd,
    bool isDisabled,
    String cabinId,
    Periodicity periodicity,
    int repeatEvery,
    DateTime endDate,
    int occurrences,
  }) =>
      RecurringBooking(
        id: id,
        description: description ?? this.description,
        date: date ?? this.date,
        timeStart: timeStart ?? this.timeStart,
        timeEnd: timeEnd ?? this.timeEnd,
        isDisabled: isDisabled ?? this.isDisabled,
        cabinId: cabinId ?? this.cabinId,
        periodicity: periodicity ?? this.periodicity,
        repeatEvery: repeatEvery ?? this.repeatEvery,
        endDate: endDate != null && occurrences == null ? endDate : null,
        occurrences: occurrences != null && endDate == null
            ? occurrences
            : this.occurrences,
      );

  RecurringBookingMethod get method => _endDate != null
      ? RecurringBookingMethod.EndDate
      : RecurringBookingMethod.Occurrences;

  Duration get periodicityDuration => Duration(
        days: PeriodicityValues.periodicityInDays[periodicity] * repeatEvery,
      );

  DateTime get endDate {
    if (_endDate != null) return _endDate;

    assert(_occurrences != null);

    var recurringDateTime = date;

    for (var i = 0; i <= _occurrences; i++) {
      recurringDateTime = recurringDateTime.add(periodicityDuration);
    }

    return recurringDateTime;
  }

  set endDate(DateTime endDate) {
    _endDate = endDate;
    _occurrences = null;
  }

  int get occurrences {
    if (_occurrences != null) return _occurrences;

    assert(_endDate != null);

    var count = 0;
    var recurringDateTime = date;

    while (recurringDateTime.isBefore(_endDate)) {
      recurringDateTime = recurringDateTime.add(periodicityDuration);
      count++;
    }

    return count;
  }

  set occurrences(int occurrences) {
    _occurrences = occurrences;
    _endDate = null;
  }

  Booking asBooking({bool linked = true}) => Booking(
        id: linked ? '$id-0' : (recurringBookingId ?? id),
        description: description,
        date: date,
        timeStart: timeStart,
        timeEnd: timeEnd,
        isDisabled: isDisabled,
        cabinId: cabinId,
        recurringBookingId: linked ? id : null,
      );

  List<Booking> get bookings {
    final runningBookings = <Booking>[];
    var runningDateTime = date;
    var movedBooking = asBooking();

    var count = 0;

    while (runningDateTime.isBefore(endDate)) {
      runningBookings.add(
        movedBooking
          ..id = '$id-$count'
          ..recurringBookingId = id
          ..recurringNumber = count
          ..recurringTotalTimes = occurrences,
      );

      runningDateTime = runningDateTime.add(periodicityDuration);

      if (runningDateTime.isBefore(endDate)) {
        movedBooking = movedBooking.copyWith(date: runningDateTime);
        count++;
      }
    }

    return runningBookings;
  }

  Booking bookingOn(DateTime dateTime) => bookings.firstWhere(
        (booking) => booking.isOn(dateTime),
        orElse: () => null,
      );

  bool hasBookingOn(DateTime dateTime) => bookingOn(dateTime) != null;

  @override
  void replaceWith(covariant RecurringBooking recurringBooking) {
    periodicity = recurringBooking.periodicity;
    _endDate = recurringBooking._endDate;
    _occurrences = recurringBooking._occurrences;

    super.replaceWith(recurringBooking);
  }

  @override
  String toString() => '$occurrences × ${super.toString()}';
}

enum Periodicity {
  Daily,
  Weekly,
  Monthly,
  Annually,
}

extension PeriodicityValues on Periodicity {
  static const periodicityInDays = {
    Periodicity.Daily: 1,
    Periodicity.Weekly: 7,
    Periodicity.Monthly: 30,
    Periodicity.Annually: 365,
  };
}

enum RecurringBookingMethod {
  EndDate,
  Occurrences,
}
