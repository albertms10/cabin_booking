import 'booking.dart';

class SingleBooking extends Booking {
  SingleBooking({
    super.id,
    super.startDate,
    super.endDate,
    super.description,
    super.isLocked,
    super.cabinId,
    super.recurringBooking,
    super.recurringNumber,
  });

  SingleBooking.fromJson(super.other) : super.fromJson();

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
        startDate: startDate ?? this.startDate,
        endDate: endDate ?? this.endDate,
        description: description ?? this.description,
        isLocked: isLocked ?? this.isLocked,
        cabinId: cabinId ?? this.cabinId,
      );

  @override
  // ignore: hash_and_equals
  bool operator ==(Object other) => super == other && other is SingleBooking;
}
