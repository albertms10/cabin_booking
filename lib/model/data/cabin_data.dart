import 'package:cabin_booking/model/booking.dart';
import 'package:cabin_booking/model/cabin.dart';

List<Cabin> cabins = [
  Cabin(
    number: 1,
    components: {
      'pianos': 1,
      'benches': 1,
      'lecterns': 2,
      'chairs': 1,
    },
    bookings: [
      Booking(
        dateStart: DateTime.parse('2020-11-14 21:00:00'),
        studentName: 'Albert',
      ),
      Booking(
        dateStart: DateTime.parse('2020-11-14 16:00:00'),
        studentName: 'Eric',
      ),
      Booking(
        dateStart: DateTime.parse('2020-11-14 17:30:00'),
        studentName: 'Guillem',
      ),
      Booking(
        dateStart: DateTime.parse('2020-11-14 18:30:00'),
        studentName: 'Joan',
      ),
      Booking(
        dateStart: DateTime.parse('2020-11-14 19:00:00'),
        studentName: 'Dani',
      ),
      Booking(
        dateStart: DateTime.parse('2020-11-14 20:00:00'),
        studentName: 'Paolo',
      ),
    ],
  ),
  Cabin(
    number: 2,
    components: {
      'pianos': 1,
      'benches': 1,
      'lecterns': 2,
      'chairs': 1,
    },
  ),
  Cabin(
    number: 3,
    components: {
      'pianos': 1,
      'benches': 1,
      'lecterns': 2,
      'chairs': 1,
    },
  ),
  Cabin(
    number: 4,
    components: {
      'pianos': 1,
      'benches': 1,
      'lecterns': 2,
      'chairs': 1,
    },
    bookings: [
      Booking(
        dateStart: DateTime.now(),
        studentName: 'Albert',
      ),
      Booking(
        dateStart: DateTime.now(),
        studentName: 'Eric',
      ),
    ],
  ),
  Cabin(
    number: 5,
    components: {
      'pianos': 1,
      'benches': 1,
      'lecterns': 2,
      'chairs': 1,
    },
  ),
  Cabin(
    number: 6,
    components: {
      'pianos': 1,
      'benches': 1,
      'lecterns': 2,
      'chairs': 1,
    },
  ),
];
