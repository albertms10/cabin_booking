import 'booking.dart';

class SingleBooking extends Booking {
  SingleBooking({
    super.id,
    super.startDate,
    super.endDate,
    super.description,
    super.isLocked,
    super.cabinId,
    super.recurringBookingId,
    super.recurringNumber,
    super.recurringTotalTimes,
  });

  SingleBooking.from(super.other) : super.from();

  SingleBooking.fromBooking(Booking booking)
      : super(
          id: booking.id,
          startDate: booking.startDate,
          endDate: booking.endDate,
          description: booking.description,
          isLocked: booking.isLocked,
          cabinId: booking.cabinId,
        );

  @override
  SingleBooking copyWith({
    String? id,
    DateTime? startDate,
    DateTime? endDate,
    String? description,
    bool? isLocked,
    String? cabinId,
  }) =>
      SingleBooking(
        id: id ?? super.id,
        startDate: startDate ?? startDate,
        endDate: endDate ?? endDate,
        description: description ?? this.description,
        isLocked: isLocked ?? this.isLocked,
        cabinId: cabinId ?? this.cabinId,
      );
}
