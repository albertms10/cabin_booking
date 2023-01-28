import '../cabin/cabin.dart';
import 'booking.dart';
import 'recurring_booking.dart';
import 'single_booking.dart';

class RecurringBookingOccurrence extends SingleBooking {
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
  bool operator ==(Object other) =>
      super == other &&
      other is RecurringBookingOccurrence &&
      recurringBooking == other.recurringBooking &&
      recurringNumber == other.recurringNumber;

  @override
  int get hashCode => Object.hash(
        super.hashCode,
        recurringBooking,
        recurringNumber,
      );
}
