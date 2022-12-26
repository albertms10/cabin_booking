import '../cabin/cabin.dart';
import 'booking.dart';

class SingleBooking extends Booking {
  SingleBooking({
    super.id,
    super.startDate,
    super.endDate,
    super.description,
    super.isLocked,
    super.cabin,
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
          cabin: booking.cabin,
        );

  @override
  SingleBooking copyWith({
    String? id,
    DateTime? startDate,
    DateTime? endDate,
    String? description,
    bool? isLocked,
    Cabin? cabin,
  }) =>
      SingleBooking(
        id: id ?? super.id,
        startDate: startDate ?? startDate,
        endDate: endDate ?? endDate,
        description: description ?? this.description,
        isLocked: isLocked ?? this.isLocked,
        cabin: cabin ?? this.cabin,
      );

  @override
  // ignore: hash_and_equals
  bool operator ==(Object other) => super == other && other is SingleBooking;
}
