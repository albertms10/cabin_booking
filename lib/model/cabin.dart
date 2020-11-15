import 'package:cabin_booking/model/booking.dart';
import 'package:cabin_booking/model/booking_manager.dart';

class Cabin {
  final String id;
  int number;
  Map<String, int> components;
  BookingManager bookingManager;

  Cabin({
    this.id,
    this.number,
    this.components = const {},
    List<Booking> bookings = const [],
  }) {
    bookingManager = BookingManager(bookings);
  }

  Cabin get simple => Cabin(id: id, number: number);

  List<Booking> get bookings => bookingManager.bookings;

  List<Booking> bookingsOn(DateTime dateTime) =>
      bookingManager.bookingsOn(dateTime);

  @override
  String toString() => 'Cabin $number (${bookings.length} bookings)';
}
