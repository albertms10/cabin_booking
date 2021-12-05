import 'package:collection/collection.dart' show IterableExtension;
import 'package:flutter/material.dart';

import 'booking.dart';

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
    String? id,
    String? description,
    DateTime? date,
    TimeOfDay? startTime,
    TimeOfDay? endTime,
    BookingStatus status = BookingStatus.pending,
    bool isLocked = false,
    String? cabinId,
    this.periodicity = Periodicity.weekly,
    this.repeatEvery = 1,
    DateTime? recurringEndDate,
    int? occurrences,
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
          isLocked: isLocked,
          cabinId: cabinId,
        );

  RecurringBooking.from(Map<String, dynamic> other)
      : periodicity = Periodicity.values[other[_JsonFields.periodicity] as int],
        repeatEvery = other[_JsonFields.repeatEvery] as int,
        _recurringEndDate = other.containsKey(_JsonFields.recurringEndDate)
            ? DateTime.tryParse(other[_JsonFields.recurringEndDate] as String)
            : null,
        _occurrences = other.containsKey(_JsonFields.occurrences)
            ? other[_JsonFields.occurrences] as int?
            : null,
        super.from(other);

  RecurringBooking.fromBooking(
    Booking booking, {
    this.periodicity = Periodicity.weekly,
    this.repeatEvery = 1,
    DateTime? recurringEndDate,
    int? occurrences,
  })  : assert((recurringEndDate == null) != (occurrences == null)),
        _recurringEndDate = recurringEndDate,
        _occurrences = occurrences,
        super(
          id: booking.id,
          description: booking.description,
          date: booking.date,
          startTime: booking.startTime,
          endTime: booking.endTime,
          status: booking.status,
          isLocked: booking.isLocked,
          cabinId: booking.cabinId,
        );

  static bool isRecurringBooking(Booking? booking) =>
      booking is RecurringBooking || booking!.recurringBookingId != null;

  @override
  Map<String, dynamic> toJson() => {
        ...super.toJson(),
        _JsonFields.periodicity: periodicity.index,
        _JsonFields.repeatEvery: repeatEvery,
        if (method == RecurringBookingMethod.endDate)
          _JsonFields.recurringEndDate:
              _recurringEndDate!.toIso8601String().split('T').first
        else if (method == RecurringBookingMethod.occurrences)
          _JsonFields.occurrences: _occurrences,
      };

  RecurringBookingMethod get method => _recurringEndDate != null
      ? RecurringBookingMethod.endDate
      : RecurringBookingMethod.occurrences;

  Duration get periodicityDuration => Duration(
        days: PeriodicityValues.periodicityInDays[periodicity]! * repeatEvery,
      );

  DateTime get recurringEndDate {
    if (_recurringEndDate != null) return _recurringEndDate!;

    assert(_occurrences != null);

    return date!.add(periodicityDuration * _occurrences!);
  }

  set recurringEndDate(DateTime date) {
    _recurringEndDate = date;
    _occurrences = null;
  }

  int get occurrences {
    if (_occurrences != null) return _occurrences!;

    assert(_recurringEndDate != null);

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

  Booking asBooking({bool linked = true}) => Booking(
        id: linked ? '$id-0' : (recurringBookingId ?? id),
        description: description,
        date: date,
        startTime: startTime,
        endTime: endTime,
        status: status,
        isLocked: isLocked,
        cabinId: cabinId,
        recurringBookingId: linked ? id : null,
      );

  List<Booking> get bookings {
    final runBookings = <Booking>[];
    var runDate = date!;
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

  Booking? bookingOn(DateTime dateTime) => bookings.firstWhereOrNull(
        (booking) => booking.isOn(dateTime),
      );

  bool hasBookingOn(DateTime dateTime) => bookingOn(dateTime) != null;

  @override
  RecurringBooking copyWith({
    String? id,
    String? description,
    DateTime? date,
    TimeOfDay? startTime,
    TimeOfDay? endTime,
    BookingStatus? status,
    bool? isLocked,
    String? cabinId,
    Periodicity? periodicity,
    int? repeatEvery,
    DateTime? endDate,
    int? occurrences,
  }) =>
      RecurringBooking(
        id: id ?? this.id,
        description: description ?? this.description,
        date: date ?? this.date,
        startTime: startTime ?? this.startTime,
        endTime: endTime ?? this.endTime,
        status: status ?? this.status,
        isLocked: isLocked ?? this.isLocked,
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
  void replaceWith(covariant RecurringBooking item) {
    periodicity = item.periodicity;
    _recurringEndDate = item._recurringEndDate;
    _occurrences = item._occurrences;

    super.replaceWith(item);
  }

  @override
  String toString() => '$occurrences × ${super.toString()}';
}

enum Periodicity { daily, weekly, monthly, annually }

extension PeriodicityValues on Periodicity {
  static const periodicityInDays = {
    Periodicity.daily: 1,
    Periodicity.weekly: 7,
    Periodicity.monthly: 30,
    Periodicity.annually: 365,
  };
}

enum RecurringBookingMethod { endDate, occurrences }
