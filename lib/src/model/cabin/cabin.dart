import 'package:flutter/material.dart';

import '../booking/booking.dart';
import '../booking/booking_manager.dart';
import '../booking/recurring_booking.dart';
import '../booking/single_booking.dart';
import '../date/date_ranger.dart';
import '../item.dart';
import 'cabin_elements.dart';

abstract class _JsonFields {
  static const number = 'n';
  static const elements = 'e';
  static const bookings = 'b';
  static const recurringBookings = 'rb';
}

/// A cabin item.
class Cabin extends Item {
  int number;
  late CabinElements elements;
  final BookingManager _bookingManager;

  /// Creates a new [Cabin].
  Cabin({
    super.id,
    this.number = 0,
    CabinElements? elements,
    Set<SingleBooking>? bookings,
    Set<RecurringBooking>? recurringBookings,
  }) : _bookingManager = BookingManager(
          bookings: bookings,
          recurringBookings: recurringBookings,
        ) {
    this.elements = elements ?? CabinElements();
  }

  /// Creates a new [Cabin] from a JSON Map.
  Cabin.fromJson(super.other)
      : number = other[_JsonFields.number] as int,
        elements = CabinElements.fromJson(
          other[_JsonFields.elements] as Map<String, dynamic>,
        ),
        _bookingManager = BookingManager.fromJson(
          bookings: other[_JsonFields.bookings] as List<dynamic>,
          recurringBookings:
              other[_JsonFields.recurringBookings] as List<dynamic>,
        ),
        super.fromJson();

  @override
  Map<String, dynamic> toJson() => {
        ...super.toJson(),
        _JsonFields.number: number,
        _JsonFields.elements: elements.toJson(),
        _JsonFields.bookings: _bookingManager.singleBookingsToJson(),
        _JsonFields.recurringBookings:
            _bookingManager.recurringBookingsToJson(),
      };

  Cabin simplified() => Cabin(id: id, number: number);

  Set<SingleBooking> get bookings => _bookingManager.bookings;

  Set<RecurringBooking> get recurringBookings =>
      _bookingManager.recurringBookings;

  Set<Booking> get allBookings => _bookingManager.allBookings;

  Set<Booking> bookingsBetween(DateRanger dateRange) =>
      _bookingManager.singleBookingsBetween(dateRange);

  Set<Booking> recurringBookingsBetween(DateRanger dateRange) =>
      _bookingManager.recurringBookingsBetween(dateRange);

  List<Booking> get generatedBookingsFromRecurring =>
      _bookingManager.singleBookingsFromRecurring;

  bool bookingsOverlapWith(Booking booking) =>
      _bookingManager.bookingsOverlapWith(booking);

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

  void addSingleBooking(SingleBooking booking) =>
      _bookingManager.addSingleBooking(booking);

  void addRecurringBooking(RecurringBooking recurringBooking) =>
      _bookingManager.addRecurringBooking(recurringBooking);

  void modifySingleBooking(SingleBooking booking) =>
      _bookingManager.modifySingleBooking(booking);

  void modifyRecurringBooking(RecurringBooking recurringBooking) =>
      _bookingManager.modifyRecurringBooking(recurringBooking);

  void removeSingleBookingById(String? id) =>
      _bookingManager.removeSingleBookingById(id);

  void removeRecurringBookingById(String? id) =>
      _bookingManager.removeRecurringBookingById(id);

  void emptyAllBookings() => _bookingManager.emptyAllBookings();

  SingleBooking singleBookingFromId(String id) =>
      _bookingManager.singleBookingFromId(id);

  RecurringBooking recurringBookingFromId(String id) =>
      _bookingManager.recurringBookingFromId(id);

  Set<Booking> allBookingsOn(DateTime dateTime) =>
      _bookingManager.allBookingsOn(dateTime);

  Iterable<Booking> searchBookings(String query, {int? limit}) =>
      _bookingManager
          .searchBookings(query, limit: limit)
          .map((booking) => booking.copyWith(cabin: this));

  @override
  String toString() => '$number';

  @override
  int compareTo(covariant Cabin other) => number.compareTo(other.number);
}
