import 'package:cabin_booking/model/booking.dart';
import 'package:cabin_booking/model/booking_manager.dart';
import 'package:cabin_booking/model/cabin_components.dart';
import 'package:cabin_booking/model/date_range.dart';
import 'package:cabin_booking/model/item.dart';
import 'package:cabin_booking/model/recurring_booking.dart';
import 'package:flutter/material.dart';

class Cabin extends Item {
  int number;
  late CabinComponents components;
  final BookingManager _bookingManager;

  Cabin({
    String? id,
    this.number = 0,
    CabinComponents? components,
    Set<Booking>? bookings,
    Set<RecurringBooking>? recurringBookings,
  })  : _bookingManager = BookingManager(
          bookings: bookings,
          recurringBookings: recurringBookings,
        ),
        super(id: id) {
    this.components = components ?? CabinComponents();
  }

  Cabin.from(Map<String, dynamic> other)
      : number = other['number'] as int,
        components =
            CabinComponents.from(other['components'] as Map<String, dynamic>),
        _bookingManager = BookingManager.from(
          bookings: other['bookings'] as List<dynamic>,
          recurringBookings: other['recurringBookings'] as List<dynamic>,
        ),
        super.from(other);

  @override
  Map<String, dynamic> toJson() => {
        ...super.toJson(),
        'number': number,
        'components': components.toJson(),
        'bookings': _bookingManager.bookingsToJson(),
        'recurringBookings': _bookingManager.recurringBookingsToJson(),
      };

  Cabin simplified() => Cabin(id: id, number: number);

  Set<Booking> get bookings => _bookingManager.bookings;

  Set<RecurringBooking> get recurringBookings =>
      _bookingManager.recurringBookings;

  Set<Booking> get allBookings => _bookingManager.allBookings;

  Set<Booking> bookingsBetween(DateRange dateRange) =>
      _bookingManager.bookingsBetween(dateRange);

  Set<Booking> recurringBookingsBetween(DateRange dateRange) =>
      _bookingManager.recurringBookingsBetween(dateRange);

  List<Booking> get generatedBookingsFromRecurring =>
      _bookingManager.generatedBookingsFromRecurring;

  bool bookingsCollideWith(Booking booking) =>
      _bookingManager.bookingsCollideWith(booking);

  Duration occupiedDuration({DateTime? dateTime, DateRange? dateRange}) =>
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

  Set<DateTime> datesWithBookings([DateRange? dateRange]) =>
      _bookingManager.datesWithBookings(dateRange);

  Map<DateTime, int> get allBookingsCountPerDay =>
      _bookingManager.allBookingsCountPerDay;

  Map<DateTime, Duration> occupiedDurationPerWeek([DateRange? dateRange]) =>
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
    DateRange? dateRange,
  ]) =>
      _bookingManager.accumulatedTimeRangesOccupancy(dateRange);

  Set<TimeOfDay> mostOccupiedTimeRange([DateRange? dateRange]) =>
      _bookingManager.mostOccupiedTimeRange(dateRange);

  @override
  Cabin copyWith({
    int? number,
    CabinComponents? components,
  }) =>
      Cabin(
        id: id,
        number: number ?? this.number,
        components: components ?? this.components,
      );

  @override
  void replaceWith(covariant Cabin item) {
    number = item.number;
    components = item.components;

    super.replaceWith(item);
  }

  void addBooking(Booking booking) => _bookingManager.addBooking(booking);

  void addRecurringBooking(RecurringBooking recurringBooking) =>
      _bookingManager.addRecurringBooking(recurringBooking);

  void modifyBooking(Booking booking) => _bookingManager.modifyBooking(booking);

  void modifyRecurringBooking(RecurringBooking recurringBooking) =>
      _bookingManager.modifyRecurringBooking(recurringBooking);

  void modifyBookingStatusById(String? id, BookingStatus status) =>
      _bookingManager.modifyBookingStatusById(id, status);

  void modifyRecurringBookingStatusById(String id, BookingStatus status) =>
      _bookingManager.modifyRecurringBookingStatusById(id, status);

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
