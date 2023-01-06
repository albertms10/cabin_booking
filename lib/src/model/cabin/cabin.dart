import 'package:flutter/material.dart';

import '../booking/booking.dart';
import '../booking/recurring_booking.dart';
import '../booking/single_booking.dart';
import '../booking_collection.dart';
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
  final BookingCollection _bookingCollection;

  /// Creates a new [Cabin].
  Cabin({
    super.id,
    this.number = 0,
    CabinElements? elements,
    Set<SingleBooking>? bookings,
    Set<RecurringBooking>? recurringBookings,
  }) : _bookingCollection = BookingCollection(
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
        _bookingCollection = BookingCollection.fromJson(
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
        _JsonFields.bookings: _bookingCollection.singleBookingsToJson(),
        _JsonFields.recurringBookings:
            _bookingCollection.recurringBookingsToJson(),
      };

  Cabin simplified() => Cabin(id: id, number: number);

  Set<SingleBooking> get bookings => _bookingCollection.bookings;

  Set<RecurringBooking> get recurringBookings =>
      _bookingCollection.recurringBookings;

  Set<Booking> get allBookings => _bookingCollection.allBookings;

  Set<Booking> bookingsBetween(DateRanger dateRange) =>
      _bookingCollection.singleBookingsBetween(dateRange);

  Set<Booking> recurringBookingsBetween(DateRanger dateRange) =>
      _bookingCollection.recurringBookingsBetween(dateRange);

  List<Booking> get generatedBookingsFromRecurring =>
      _bookingCollection.singleBookingsFromRecurring;

  bool bookingsOverlapWith(Booking booking) =>
      _bookingCollection.bookingsOverlapWith(booking);

  Duration occupiedDuration({DateTime? dateTime, DateRanger? dateRange}) =>
      _bookingCollection.occupiedDuration(
        dateTime: dateTime,
        dateRange: dateRange,
      );

  double occupancyPercentOn(
    DateTime? dateTime, {
    required TimeOfDay startTime,
    required TimeOfDay endTime,
  }) =>
      _bookingCollection.occupancyPercentOn(
        dateTime,
        startTime: startTime,
        endTime: endTime,
      );

  Set<DateTime> datesWithBookings([DateRanger? dateRange]) =>
      _bookingCollection.datesWithBookings(dateRange);

  Map<DateTime, int> get allBookingsCountPerDay =>
      _bookingCollection.allBookingsCountPerDay;

  Map<DateTime, Duration> occupiedDurationPerWeek([DateRanger? dateRange]) =>
      _bookingCollection.occupiedDurationPerWeek(dateRange);

  double occupancyPercent({
    required TimeOfDay startTime,
    required TimeOfDay endTime,
    Set<DateTime>? dates,
  }) =>
      _bookingCollection.occupancyPercent(
        startTime: startTime,
        endTime: endTime,
        dates: dates,
      );

  Map<TimeOfDay, Duration> accumulatedTimeRangesOccupancy([
    DateRanger? dateRange,
  ]) =>
      _bookingCollection.accumulatedTimeRangesOccupancy(dateRange);

  Set<TimeOfDay> mostOccupiedTimeRange([DateRanger? dateRange]) =>
      _bookingCollection.mostOccupiedTimeRange(dateRange);

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
      _bookingCollection.addSingleBooking(booking);

  void addRecurringBooking(RecurringBooking recurringBooking) =>
      _bookingCollection.addRecurringBooking(recurringBooking);

  void modifySingleBooking(SingleBooking booking) =>
      _bookingCollection.modifySingleBooking(booking);

  void modifyRecurringBooking(RecurringBooking recurringBooking) =>
      _bookingCollection.modifyRecurringBooking(recurringBooking);

  void removeSingleBookingById(String? id) =>
      _bookingCollection.removeSingleBookingById(id);

  void removeRecurringBookingById(String? id) =>
      _bookingCollection.removeRecurringBookingById(id);

  void emptyAllBookings() => _bookingCollection.emptyAllBookings();

  SingleBooking singleBookingFromId(String id) =>
      _bookingCollection.singleBookingFromId(id);

  RecurringBooking recurringBookingFromId(String id) =>
      _bookingCollection.recurringBookingFromId(id);

  Set<Booking> allBookingsOn(DateTime dateTime) =>
      _bookingCollection.allBookingsOn(dateTime);

  Iterable<Booking> searchBookings(String query, {int? limit}) =>
      _bookingCollection
          .searchBookings(query, limit: limit)
          .map((booking) => booking.copyWith(cabin: this));

  @override
  String toString() => '$number';

  @override
  int compareTo(covariant Cabin other) => number.compareTo(other.number);
}
