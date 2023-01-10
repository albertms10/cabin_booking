import '../booking/booking.dart';
import '../booking/recurring_booking.dart';
import '../booking/single_booking.dart';
import '../booking_collection.dart';
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
  final BookingCollection bookingCollection;

  /// Creates a new [Cabin].
  Cabin({
    super.id,
    this.number = 0,
    CabinElements? elements,
    Set<SingleBooking>? bookings,
    Set<RecurringBooking>? recurringBookings,
  }) : bookingCollection = BookingCollection(
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
        bookingCollection = BookingCollection.fromJson(
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
        _JsonFields.bookings: bookingCollection.singleBookingsToJson(),
        _JsonFields.recurringBookings:
            bookingCollection.recurringBookingsToJson(),
      };

  Cabin simplified() => Cabin(id: id, number: number);

  @override
  Cabin copyWith({
    String? id,
    int? number,
    CabinElements? elements,
    Set<SingleBooking>? bookings,
    Set<RecurringBooking>? recurringBookings,
  }) =>
      Cabin(
        id: id ?? this.id,
        number: number ?? this.number,
        elements: elements ?? this.elements,
        bookings: bookings ?? bookingCollection.bookings,
        recurringBookings:
            recurringBookings ?? bookingCollection.recurringBookings,
      );

  @override
  void replaceWith(covariant Cabin item) {
    number = item.number;
    elements = item.elements;

    super.replaceWith(item);
  }

  Iterable<Booking> searchBookings(String query, {int? limit}) =>
      bookingCollection
          .searchBookings(query, limit: limit)
          .map((booking) => booking.copyWith(cabin: this));

  @override
  String toString() => '$number';

  @override
  int compareTo(covariant Cabin other) => number.compareTo(other.number);
}
