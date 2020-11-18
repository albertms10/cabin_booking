import 'package:cabin_booking/model/booking.dart';

class RecurringBooking extends Booking {
  Duration periodicity;
  DateTime _until;
  int _times;

  RecurringBooking({
    id,
    studentName,
    dateStart,
    dateEnd,
    cabinId,
    this.periodicity = const Duration(days: 7),
    until,
    times,
  })  : assert((until == null) != (times == null)),
        _until = until,
        _times = times,
        super(
          id: id,
          studentName: studentName,
          dateStart: dateStart,
          dateEnd: dateEnd,
          cabinId: cabinId,
        );

  RecurringBooking.from(Map<String, dynamic> other)
      : periodicity = Duration(days: other['periodicity']),
        _until = DateTime.tryParse(other['until']),
        _times = other['times'],
        super(
          id: other['id'],
          studentName: other['studentName'],
          dateStart: DateTime.tryParse(other['dateStart']),
          dateEnd: DateTime.tryParse(other['dateEnd']),
        );

  Map<String, dynamic> toMap() => {
        ...super.toMap(),
        'periodicity': periodicity.inDays,
        'until': until.toIso8601String(),
        'times': times,
      };

  DateTime get until {
    if (_until != null) return _until;

    DateTime recurringDateTime = dateStart;

    for (int i = 0; i < times; i++)
      recurringDateTime = recurringDateTime.add(periodicity);

    return recurringDateTime;
  }

  int get times {
    if (_times != null) return _times;

    int count = 0;
    DateTime recurringDateTime = dateStart;

    while (recurringDateTime.isBefore(until)) {
      recurringDateTime = recurringDateTime.add(periodicity);
      count++;
    }

    return count;
  }

  Booking get booking => Booking(
        id: id,
        studentName: studentName,
        dateStart: dateStart,
        dateEnd: dateEnd,
        cabinId: cabinId,
      );

  List<Booking> get bookings {
    List<Booking> _bookings = [];

    DateTime recurringDateTime = dateStart;
    Booking movedBooking = booking;

    while (recurringDateTime.isBefore(until)) {
      recurringDateTime = recurringDateTime.add(periodicity);
      movedBooking = movedBooking.movedTo(recurringDateTime);
      _bookings.add(movedBooking);
    }

    return _bookings;
  }

  bool hasBookingOn(DateTime dateTime) =>
      bookings.contains((booking) => booking.isOn(dateTime));

  @override
  String toString() => '$times × ' + super.toString();
}
