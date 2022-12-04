import 'booking.dart';

class SingleBooking extends Booking {
  SingleBooking({
    super.id,
    super.description,
    super.startDate,
    super.endDate,
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
          startDate: booking.startDate,
          endDate: booking.endDate,
          isLocked: booking.isLocked,
          cabinId: booking.cabinId,
        );

  @override
  SingleBooking copyWith({
    String? id,
    String? description,
    DateTime? startDate,
    DateTime? endDate,
    bool? isLocked,
    String? cabinId,
  }) =>
      SingleBooking(
        id: id ?? super.id,
        description: description ?? this.description,
        startDate: startDate ?? startDate,
        endDate: endDate ?? endDate,
        isLocked: isLocked ?? this.isLocked,
        cabinId: cabinId ?? this.cabinId,
      );
}
