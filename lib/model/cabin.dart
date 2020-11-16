import 'package:cabin_booking/model/booking.dart';
import 'package:cabin_booking/model/booking_manager.dart';

class Cabin {
  String id;
  int number;
  Map<String, int> components;
  BookingManager bookingManager;

  Cabin({
    this.id,
    this.number,
    this.components,
    List<Booking> bookings,
  }) : bookingManager = BookingManager(bookings: bookings) {
    if (components == null) components = Map<String, int>();
  }

  Cabin.from(Map<String, dynamic> other)
      : id = other['id'],
        number = other['number'],
        components = Map<String, int>.from(other['components'] ?? const {}),
        bookingManager = BookingManager.from(other['bookings'] ?? const []);

  Map<String, dynamic> toMap() => {
        'id': id,
        'number': number,
        'components': components,
        'bookings': bookingManager.bookingsToMapList(),
      };

  Cabin get simple => Cabin(id: id, number: number);

  List<Booking> get bookings => bookingManager.bookings;

  List<Booking> bookingsOn(DateTime dateTime) =>
      bookingManager.bookingsOn(dateTime);

  @override
  String toString() => 'Cabin $number (${bookings.length} bookings)';

  @override
  bool operator ==(other) => other is Cabin && this.id == other.id;

  @override
  int get hashCode => id.hashCode;
}
