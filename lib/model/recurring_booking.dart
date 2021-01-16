import 'package:cabin_booking/model/booking.dart';
import 'package:flutter/material.dart';

class RecurringBooking extends Booking {
  Periodicity periodicity;
  int repeatEvery;

  DateTime _recurringEndDate;
  int _occurrences;

  RecurringBooking({
    String id,
    String description,
    DateTime date,
    TimeOfDay startTime,
    TimeOfDay endTime,
    BookingStatus status,
    bool isDisabled = false,
    String cabinId,
    this.periodicity = Periodicity.Weekly,
    this.repeatEvery = 1,
    DateTime recurringEndDate,
    int occurrences,
  })  : assert((recurringEndDate == null) != (occurrences == null)),
        _recurringEndDate = recurringEndDate,
        _occurrences = occurrences,
        super(
          id: id,
          description: description,
          date: date,
          startTime: startTime,
          endTime: endTime,
          status: status,
          isDisabled: isDisabled,
          cabinId: cabinId,
        );

  RecurringBooking.from(Map<String, dynamic> other)
      : periodicity = Periodicity.values[other['periodicityIndex'] as int],
        repeatEvery = other['repeatEvery'] as int,
        _recurringEndDate = other.containsKey('endDate')
            ? DateTime.tryParse(other['endDate'] as String)
            : null,
        _occurrences = other.containsKey('occurrences')
            ? other['occurrences'] as int
            : null,
        super.from(other);

  RecurringBooking.fromBooking(
    Booking booking, {
    Periodicity periodicity = Periodicity.Weekly,
    int repeatEvery = 1,
    DateTime recurringEndDate,
    int occurrences,
  })  : assert((recurringEndDate == null) != (occurrences == null)),
        periodicity = periodicity,
        repeatEvery = repeatEvery,
        _recurringEndDate = recurringEndDate,
        _occurrences = occurrences,
        super(
          id: booking.id,
          description: booking.description,
          date: booking.date,
          startTime: booking.startTime,
          endTime: booking.endTime,
          status: booking.status,
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
          'endDate': _recurringEndDate.toIso8601String().split('T').first
        else if (method == RecurringBookingMethod.Occurrences)
          'occurrences': _occurrences,
      };

  RecurringBookingMethod get method => _recurringEndDate != null
      ? RecurringBookingMethod.EndDate
      : RecurringBookingMethod.Occurrences;

  Duration get periodicityDuration => Duration(
        days: PeriodicityValues.periodicityInDays[periodicity] * repeatEvery,
      );

  DateTime get recurringEndDate {
    if (_recurringEndDate != null) return _recurringEndDate;

    assert(_occurrences != null);

    return date.add(periodicityDuration * _occurrences);
  }

  set recurringEndDate(DateTime date) {
    _recurringEndDate = date;
    _occurrences = null;
  }

  int get occurrences {
    if (_occurrences != null) return _occurrences;

    assert(_recurringEndDate != null);

    var count = 0;
    var runDate = date;

    while (runDate.isBefore(_recurringEndDate)) {
      runDate = runDate.add(periodicityDuration);
      count++;
    }

    return count;
  }

  set occurrences(int occurrences) {
    _occurrences = occurrences;
    _recurringEndDate = null;
  }

  Booking asBooking({bool linked = true}) => Booking(
        id: linked ? '$id-0' : (recurringBookingId ?? id),
        description: description,
        date: date,
        startTime: startTime,
        endTime: endTime,
        status: status,
        isDisabled: isDisabled,
        cabinId: cabinId,
        recurringBookingId: linked ? id : null,
      );

  List<Booking> get bookings {
    final runBookings = <Booking>[];
    var runDate = date;
    var movedBooking = asBooking();

    var count = 0;

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
        movedBooking = movedBooking.copyWith(date: runDate);
        count++;
      }
    }

    return runBookings;
  }

  Booking bookingOn(DateTime dateTime) => bookings.firstWhere(
        (booking) => booking.isOn(dateTime),
        orElse: () => null,
      );

  bool hasBookingOn(DateTime dateTime) => bookingOn(dateTime) != null;

  @override
  RecurringBooking copyWith({
    String description,
    DateTime date,
    TimeOfDay startTime,
    TimeOfDay endTime,
    BookingStatus status,
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
        startTime: startTime ?? this.startTime,
        endTime: endTime ?? this.endTime,
        status: status ?? this.status,
        isDisabled: isDisabled ?? this.isDisabled,
        cabinId: cabinId ?? this.cabinId,
        periodicity: periodicity ?? this.periodicity,
        repeatEvery: repeatEvery ?? this.repeatEvery,
        recurringEndDate:
            endDate != null && occurrences == null ? endDate : null,
        occurrences: occurrences != null && endDate == null
            ? occurrences
            : this.occurrences,
      );

  @override
  void replaceWith(covariant RecurringBooking recurringBooking) {
    periodicity = recurringBooking.periodicity;
    _recurringEndDate = recurringBooking._recurringEndDate;
    _occurrences = recurringBooking._occurrences;

    super.replaceWith(recurringBooking);
  }

  @override
  String toString() => '$occurrences × ${super.toString()}';
}

enum Periodicity { Daily, Weekly, Monthly, Annually }

extension PeriodicityValues on Periodicity {
  static const periodicityInDays = {
    Periodicity.Daily: 1,
    Periodicity.Weekly: 7,
    Periodicity.Monthly: 30,
    Periodicity.Annually: 365,
  };
}

enum RecurringBookingMethod { EndDate, Occurrences }
