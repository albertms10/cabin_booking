import '../booking/booking.dart';
import '../booking_collection.dart';
import '../item.dart';
import 'cabin_elements.dart';

abstract class _JsonFields {
  static const number = 'n';
  static const elements = 'e';
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
    BookingCollection? bookingCollection,
  })  : elements = elements ?? CabinElements(),
        bookingCollection = bookingCollection ?? BookingCollection();

  /// Creates a new [Cabin] from a JSON Map.
  Cabin.fromJson(super.other)
      : number = other[_JsonFields.number] as int,
        elements = CabinElements.fromJson(
          other[_JsonFields.elements] as Map<String, dynamic>,
        ),
        bookingCollection = BookingCollection.fromJson(other),
        super.fromJson();

  @override
  Map<String, dynamic> toJson() => {
        ...super.toJson(),
        _JsonFields.number: number,
        _JsonFields.elements: elements.toJson(),
        ...bookingCollection.toJson(),
      };

  Cabin simplified() => Cabin(id: id, number: number);

  @override
  Cabin copyWith({
    String? id,
    int? number,
    CabinElements? elements,
    BookingCollection? bookingCollection,
  }) =>
      Cabin(
        id: id ?? this.id,
        number: number ?? this.number,
        elements: elements ?? this.elements,
        bookingCollection: bookingCollection ?? this.bookingCollection,
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
