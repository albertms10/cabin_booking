import 'package:flutter/material.dart';

import '../booking/booking.dart';
import '../booking/booking_manager.dart';
import '../booking/recurring_booking.dart';
import '../date/date_range.dart';
import '../item.dart';
import 'cabin_elements.dart';

abstract class _JsonFields {
  static const number = 'n';
  static const elements = 'e';
  static const bookings = 'b';
  static const recurringBookings = 'rb';
}

class Cabin extends Item {
  int number;
  late CabinElements elements;
  final BookingManager _bookingManager;

  Cabin({
    super.id,
    this.number = 0,
    CabinElements? elements,
    Set<Booking>? bookings,
    Set<RecurringBooking>? recurringBookings,
  }) : _bookingManager = BookingManager(
          bookings: bookings,
          recurringBookings: recurringBookings,
        ) {
    this.elements = elements ?? CabinElements();
  }

  Cabin.from(super.other)
      : number = other[_JsonFields.number] as int,
        elements = CabinElements.from(
          other[_JsonFields.elements] as Map<String, dynamic>,
        ),
        _bookingManager = BookingManager.from(
          bookings: other[_JsonFields.bookings] as List<dynamic>,
          recurringBookings:
              other[_JsonFields.recurringBookings] as List<dynamic>,
        ),
        super.from();

  @override
  Map<String, dynamic> toJson() => {
        ...super.toJson(),
        _JsonFields.number: number,
        _JsonFields.elements: elements.toJson(),
        _JsonFields.bookings: _bookingManager.bookingsToJson(),
        _JsonFields.recurringBookings:
            _bookingManager.recurringBookingsToJson(),
      };

  Cabin simplified() => Cabin(id: id, number: number);

  Set<Booking> get bookings => _bookingManager.bookings;

  Set<RecurringBooking> get recurringBookings =>
      _bookingManager.recurringBookings;

  Set<Booking> get allBookings => _bookingManager.allBookings;

  Set<Booking> bookingsBetween(DateRanger dateRange) =>
      _bookingManager.bookingsBetween(dateRange);

  Set<Booking> recurringBookingsBetween(DateRanger dateRange) =>
      _bookingManager.recurringBookingsBetween(dateRange);

  List<Booking> get generatedBookingsFromRecurring =>
      _bookingManager.generatedBookingsFromRecurring;

  bool bookingsCollideWith(Booking booking) =>
      _bookingManager.bookingsCollideWith(booking);

  Duration occupiedDuration({DateTime? dateTime, DateRanger? dateRange}) =>
      _bookingManager.occupiedDuration(
        dateTime: dateTime,
        dateRange: dateRange,
      );

  double occupancyPercentOn(
    DateTime? dateTime, {
    required TimeOfDay startTime,
    required TimeOfDay endTime,
  }) =>
      _bookingManager.occupancyPercentOn(
        dateTime,
        startTime: startTime,
        endTime: endTime,
      );

  Set<DateTime> datesWithBookings([DateRanger? dateRange]) =>
      _bookingManager.datesWithBookings(dateRange);

  Map<DateTime, int> get allBookingsCountPerDay =>
      _bookingManager.allBookingsCountPerDay;

  Map<DateTime, Duration> occupiedDurationPerWeek([DateRanger? dateRange]) =>
      _bookingManager.occupiedDurationPerWeek(dateRange);

  double occupancyPercent({
    required TimeOfDay startTime,
    required TimeOfDay endTime,
    Set<DateTime>? dates,
  }) =>
      _bookingManager.occupancyPercent(
        startTime: startTime,
        endTime: endTime,
        dates: dates,
      );

  Map<TimeOfDay, Duration> accumulatedTimeRangesOccupancy([
    DateRanger? dateRange,
  ]) =>
      _bookingManager.accumulatedTimeRangesOccupancy(dateRange);

  Set<TimeOfDay> mostOccupiedTimeRange([DateRanger? dateRange]) =>
      _bookingManager.mostOccupiedTimeRange(dateRange);

  @override
  Cabin copyWith({
    int? number,
    CabinElements? elements,
  }) =>
      Cabin(
        id: id,
        number: number ?? this.number,
        elements: elements ?? this.elements,
      );

  @override
  void replaceWith(covariant Cabin item) {
    number = item.number;
    elements = item.elements;

    super.replaceWith(item);
  }

  void addBooking(Booking booking) => _bookingManager.addBooking(booking);

  void addRecurringBooking(RecurringBooking recurringBooking) =>
      _bookingManager.addRecurringBooking(recurringBooking);

  void modifyBooking(Booking booking) => _bookingManager.modifyBooking(booking);

  void modifyRecurringBooking(RecurringBooking recurringBooking) =>
      _bookingManager.modifyRecurringBooking(recurringBooking);

  void removeBookingById(String? id) => _bookingManager.removeBookingById(id);

  void removeRecurringBookingById(String? id) =>
      _bookingManager.removeRecurringBookingById(id);

  void emptyAllBookings() => _bookingManager.emptyAllBookings();

  Booking bookingFromId(String id) => _bookingManager.bookingFromId(id);

  RecurringBooking recurringBookingFromId(String id) =>
      _bookingManager.recurringBookingFromId(id);

  Set<Booking> allBookingsOn(DateTime dateTime) =>
      _bookingManager.allBookingsOn(dateTime);

  @override
  String toString() => '$number';

  @override
  int compareTo(covariant Cabin other) => number.compareTo(other.number);
}
