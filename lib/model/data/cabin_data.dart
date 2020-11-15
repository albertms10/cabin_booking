import 'package:cabin_booking/model/booking.dart';
import 'package:cabin_booking/model/cabin.dart';

List<Cabin> cabins = [
  Cabin(
    id: 'cabin-1',
    number: 1,
    components: {
      'pianos': 1,
      'benches': 1,
      'lecterns': 2,
      'chairs': 1,
    },
    bookings: [
      Booking(
        id: 'booking-1',
        dateStart: DateTime.parse('2020-11-14 21:00:00'),
        dateEnd: DateTime.parse('2020-11-14 22:00:00'),
        studentName: 'Albert',
      ),
      Booking(
        id: 'booking-2',
        dateStart: DateTime.parse('2020-11-14 16:00:00'),
        dateEnd: DateTime.parse('2020-11-14 17:00:00'),
        studentName: 'Eric',
      ),
      Booking(
        id: 'booking-3',
        dateStart: DateTime.parse('2020-11-15 17:30:00'),
        dateEnd: DateTime.parse('2020-11-15 18:00:00'),
        studentName: 'Guillem',
      ),
      Booking(
        id: 'booking-4',
        dateStart: DateTime.parse('2020-11-15 18:30:00'),
        dateEnd: DateTime.parse('2020-11-15 20:00:00'),
        studentName: 'Joan',
      ),
    ]..sort((a, b) => a.dateStart.compareTo(b.dateStart)),
  ),
  Cabin(
    id: 'cabin-2',
    number: 2,
    components: {
      'pianos': 1,
      'benches': 1,
      'lecterns': 2,
      'chairs': 1,
    },
    bookings: [
      Booking(
        id: 'booking-5',
        dateStart: DateTime.parse('2020-11-16 19:00:00'),
        dateEnd: DateTime.parse('2020-11-16 20:00:00'),
        studentName: 'Dani',
      ),
      Booking(
        id: 'booking-6',
        dateStart: DateTime.parse('2020-11-14 20:00:00'),
        dateEnd: DateTime.parse('2020-11-14 22:00:00'),
        studentName: 'Paolo',
      ),
      Booking(
        id: 'booking-7',
        dateStart: DateTime.parse('2020-11-15 20:00:00'),
        dateEnd: DateTime.parse('2020-11-15 22:00:00'),
        studentName: 'Paolo',
      ),
    ]..sort((a, b) => a.dateStart.compareTo(b.dateStart)),
  ),
  Cabin(
    id: 'cabin-3',
    number: 3,
    components: {
      'pianos': 1,
      'benches': 1,
      'lecterns': 2,
      'chairs': 1,
    },
  ),
  Cabin(
    id: 'cabin-4',
    number: 4,
    components: {
      'pianos': 1,
      'benches': 1,
      'lecterns': 2,
      'chairs': 1,
    },
    bookings: [
      Booking(
        id: 'booking-8',
        dateStart: DateTime.parse('2020-11-15 19:00:00'),
        dateEnd: DateTime.parse('2020-11-15 20:00:00'),
        studentName: 'Dani',
      ),
      Booking(
        id: 'booking-9',
        dateStart: DateTime.parse('2020-11-14 20:00:00'),
        dateEnd: DateTime.parse('2020-11-14 22:00:00'),
        studentName: 'Paolo',
      ),
    ]..sort((a, b) => a.dateStart.compareTo(b.dateStart)),
  ),
  Cabin(
    id: 'cabin-5',
    number: 5,
    components: {
      'pianos': 1,
      'benches': 1,
      'lecterns': 2,
      'chairs': 1,
    },
  ),
  Cabin(
    id: 'booking-6',
    number: 6,
    components: {
      'pianos': 1,
      'benches': 1,
      'lecterns': 2,
      'chairs': 1,
    },
  ),
];
