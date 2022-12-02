import 'booking.dart';

class SingleBooking extends Booking {
  SingleBooking({
    super.id,
    super.description,
    super.startDateTime,
    super.endDateTime,
    super.isLocked = false,
    super.cabinId,
    super.recurringBookingId,
    super.recurringNumber,
    super.recurringTotalTimes,
  });

  SingleBooking.from(super.other) : super.from();

  SingleBooking.fromBooking(Booking booking)
      : super(
          id: booking.id,
          description: booking.description,
          startDateTime: booking.startDateTime,
          endDateTime: booking.endDateTime,
          isLocked: booking.isLocked,
          cabinId: booking.cabinId,
        );

  @override
  SingleBooking copyWith({
    String? id,
    String? description,
    DateTime? startDateTime,
    DateTime? endDateTime,
    bool? isLocked,
    String? cabinId,
  }) =>
      SingleBooking(
        id: id ?? super.id,
        description: description ?? this.description,
        startDateTime: startDateTime ?? this.startDateTime,
        endDateTime: endDateTime ?? this.endDateTime,
        isLocked: isLocked ?? this.isLocked,
        cabinId: cabinId ?? this.cabinId,
      );
}
