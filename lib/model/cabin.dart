import 'package:cabin_booking/model/booking.dart';
import 'package:cabin_booking/model/booking_manager.dart';
import 'package:cabin_booking/model/cabin_components.dart';
import 'package:cabin_booking/model/item.dart';
import 'package:cabin_booking/model/recurring_booking.dart';
import 'package:flutter/material.dart';

class Cabin extends Item {
  int number;
  CabinComponents components;
  final BookingManager _bookingManager;

  Cabin({
    String id,
    this.number,
    this.components,
    List<Booking> bookings,
    List<RecurringBooking> recurringBookings,
  })  : _bookingManager = BookingManager(
          bookings: bookings,
          recurringBookings: recurringBookings,
        ),
        super(id: id) {
    components ??= CabinComponents();
  }

  Cabin.from(Map<String, dynamic> other)
      : number = other['number'],
        components = CabinComponents.from(other['components']),
        _bookingManager = BookingManager.from(
          bookings: other['bookings'],
          recurringBookings: other['recurringBookings'],
        ),
        super.from(other);

  @override
  Map<String, dynamic> toMap() => {
        ...super.toMap(),
        'number': number,
        'components': components.toMap(),
        'bookings': _bookingManager.bookingsToMapList(),
        'recurringBookings': _bookingManager.recurringBookingsToMapList(),
      };

  Cabin simplified() => Cabin(id: id, number: number);

  List<Booking> get bookings => _bookingManager.bookings;

  List<RecurringBooking> get recurringBookings =>
      _bookingManager.recurringBookings;

  List<Booking> get generatedBookingsFromRecurring =>
      _bookingManager.generatedBookingsFromRecurring;

  bool bookingsCollideWith(Booking booking) =>
      _bookingManager.bookingsCollideWith(booking);

  Duration get accumulatedDuration => _bookingManager.accumulatedDuration;

  double occupiedRatioOn(
    DateTime dateTime, {
    @required TimeOfDay startTime,
    @required TimeOfDay endTime,
  }) =>
      _bookingManager.occupiedRatioOn(
        dateTime,
        startTime: startTime,
        endTime: endTime,
      );

  List<DateTime> get datesWithBookings => _bookingManager.datesWithBookings;

  double occupiedRatio({
    @required TimeOfDay startTime,
    @required TimeOfDay endTime,
    List<DateTime> dates,
  }) =>
      _bookingManager.occupiedRatio(
        startTime: startTime,
        endTime: endTime,
        dates: dates,
      );

  Map<TimeOfDay, Duration> get accumulatedTimeRangesOccupancy =>
      _bookingManager.accumulatedTimeRangesOccupancy;

  List<TimeOfDay> get mostOccupiedTimeRanges =>
      _bookingManager.mostOccupiedTimeRange;

  void replaceWith(Cabin cabin) {
    number = cabin.number;
    components = cabin.components;

    modify();
  }

  void addBooking(Booking booking) => _bookingManager.addBooking(booking);

  void addRecurringBooking(RecurringBooking recurringBooking) =>
      _bookingManager.addRecurringBooking(recurringBooking);

  void modifyBooking(Booking booking) => _bookingManager.modifyBooking(booking);

  void modifyRecurringBooking(RecurringBooking recurringBooking) =>
      _bookingManager.modifyRecurringBooking(recurringBooking);

  void removeBookingById(String id) => _bookingManager.removeBookingById(id);

  void removeRecurringBookingById(String id) =>
      _bookingManager.removeRecurringBookingById(id);

  void emptyAllBookings() => _bookingManager.emptyAllBookings();

  Booking bookingFromId(String id) => _bookingManager.bookingFromId(id);

  RecurringBooking recurringBookingFromId(String id) =>
      _bookingManager.recurringBookingFromId(id);

  List<Booking> bookingsOn(DateTime dateTime) =>
      _bookingManager.bookingsOn(dateTime);

  @override
  String toString() => 'Cabin $number (${bookings.length} bookings)';

  @override
  bool operator ==(other) => other is Cabin && id == other.id;

  @override
  int get hashCode => id.hashCode;
}
