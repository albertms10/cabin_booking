import '../cabin/cabin.dart';
import 'booking.dart';
import 'recurring_booking.dart';

class RecurringBookingOccurrence extends Booking {
  /// The [RecurringBooking] reference, if this [Booking] is part of a series of
  /// recurring bookings.
  RecurringBooking? recurringBooking;

  /// The occurrence number this [Booking] appears in the list of recurring
  /// bookings. E.g., the 2nd occurrence out of 5.
  int? recurringNumber;

  RecurringBookingOccurrence({
    super.id,
    super.startDate,
    super.endDate,
    super.description,
    super.isLocked,
    super.cabin,
    this.recurringBooking,
    this.recurringNumber,
  });

  RecurringBookingOccurrence.fromJson(super.other) : super.fromJson();

  RecurringBookingOccurrence.fromBooking(Booking booking)
      : super(
          id: booking.id,
          startDate: booking.startDate,
          endDate: booking.endDate,
          description: booking.description,
          isLocked: booking.isLocked,
          cabin: booking.cabin,
        );

  @override
  RecurringBookingOccurrence copyWith({
    String? id,
    DateTime? startDate,
    DateTime? endDate,
    String? description,
    bool? isLocked,
    Cabin? cabin,
  }) =>
      RecurringBookingOccurrence(
        id: id ?? this.id,
        startDate: startDate ?? this.startDate,
        endDate: endDate ?? this.endDate,
        description: description ?? this.description,
        isLocked: isLocked ?? this.isLocked,
        cabin: cabin ?? this.cabin,
      );

  @override
  // ignore: hash_and_equals
  bool operator ==(Object other) =>
      super == other && other is RecurringBookingOccurrence;
}
