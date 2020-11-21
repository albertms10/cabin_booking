import 'package:cabin_booking/model/booking.dart';
import 'package:cabin_booking/model/booking_manager.dart';
import 'package:cabin_booking/model/recurring_booking.dart';

class Cabin {
  String id;
  int number;
  Map<String, int> components;
  BookingManager _bookingManager;

  Cabin({
    this.id,
    this.number,
    this.components,
    List<Booking> bookings,
    List<RecurringBooking> recurringBookings,
  }) : _bookingManager = BookingManager(
          bookings: bookings,
          recurringBookings: recurringBookings,
        ) {
    if (components == null) components = <String, int>{};
  }

  Cabin.from(Map<String, dynamic> other)
      : id = other['id'],
        number = other['number'],
        components =
            Map<String, int>.from(other['components'] ?? <String, int>{}),
        _bookingManager = BookingManager.from(
          bookings: other['bookings'] ?? <Booking>[],
          recurringBookings: other['recurringBookings'] ?? <Booking>[],
        );

  Map<String, dynamic> toMap() => {
        'id': id,
        'number': number,
        'components': components,
        'bookings': _bookingManager.bookingsToMapList(),
        'recurringBookings': _bookingManager.recurringBookingsToMapList(),
      };

  Cabin get simple => Cabin(id: id, number: number);

  List<Booking> get bookings => _bookingManager.bookings;

  bool bookingsCollideWith(Booking booking) =>
      _bookingManager.bookingsCollideWith(booking);

  void addBooking(Booking booking) => _bookingManager.addBooking(booking);

  void addRecurringBooking(RecurringBooking recurringBooking) =>
      _bookingManager.addRecurringBooking(recurringBooking);

  void modifyBooking(Booking booking) => _bookingManager.modifyBooking(booking);

  void modifyRecurringBooking(RecurringBooking recurringBooking) =>
      _bookingManager.modifyRecurringBooking(recurringBooking);

  void removeBookingById(String id) => _bookingManager.removeBookingById(id);

  void removeRecurringBookingById(String id) =>
      _bookingManager.removeRecurringBookingById(id);

  List<Booking> bookingsOn(DateTime dateTime) =>
      _bookingManager.bookingsOn(dateTime);

  @override
  String toString() => 'Cabin $number (${bookings.length} bookings)';

  @override
  bool operator ==(other) => other is Cabin && this.id == other.id;

  @override
  int get hashCode => id.hashCode;
}
