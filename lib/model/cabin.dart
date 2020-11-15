import 'package:cabin_booking/model/booking.dart';

class Cabin {
  final String id;
  int number;
  Map<String, int> components;
  List<Booking> bookings;

  Cabin({
    this.id,
    this.number,
    this.components = const {},
    this.bookings = const [],
  });

  Cabin get simple => Cabin(id: id, number: number);

  @override
  String toString() => 'Cabin $number (${bookings.length} bookings)';
}
