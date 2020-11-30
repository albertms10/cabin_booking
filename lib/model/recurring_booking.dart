import 'package:cabin_booking/model/booking.dart';

class RecurringBooking extends Booking {
  Duration periodicity;
  DateTime _until;
  int _times;

  RecurringBooking({
    id,
    studentName,
    date,
    timeStart,
    timeEnd,
    isDisabled = false,
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
          date: date,
          timeStart: timeStart,
          timeEnd: timeEnd,
          isDisabled: isDisabled,
          cabinId: cabinId,
        );

  RecurringBooking.from(Map<String, dynamic> other)
      : periodicity = Duration(days: other['periodicity']),
        _until = other.containsKey('until')
            ? DateTime.tryParse(other['until'])
            : null,
        _times = other.containsKey('times') ? other['times'] : null,
        super.from(other);

  RecurringBooking.fromBooking(Booking booking)
      : periodicity = const Duration(days: 7),
        super(
          id: booking.id,
          studentName: booking.studentName,
          date: booking.date,
          timeStart: booking.timeStart,
          timeEnd: booking.timeEnd,
          isDisabled: booking.isDisabled,
          cabinId: booking.cabinId,
        );

  @override
  Map<String, dynamic> toMap() => {
        ...super.toMap(),
        'periodicity': periodicity.inDays,
        if (_until != null) 'until': until.toIso8601String(),
        if (_times != null) 'times': times,
      };

  RecurringBookingMethod get method => _until != null
      ? RecurringBookingMethod.until
      : RecurringBookingMethod.times;

  DateTime get until {
    if (_until != null) return _until;

    assert(_times != null);

    var recurringDateTime = dateStart;

    for (var i = 0; i < _times; i++) {
      recurringDateTime = recurringDateTime.add(periodicity);
    }

    return recurringDateTime;
  }

  set until(DateTime until) {
    _until = until;
    _times = null;
  }

  int get times {
    if (_times != null) return _times;

    assert(_until != null);

    var count = 0;
    var recurringDateTime = dateStart;

    while (recurringDateTime.isBefore(_until)) {
      recurringDateTime = recurringDateTime.add(periodicity);
      count++;
    }

    return count;
  }

  set times(int times) {
    _times = times;
    _until = null;
  }

  Booking get booking => Booking(
        id: '$id-0',
        studentName: studentName,
        date: date,
        timeStart: timeStart,
        timeEnd: timeEnd,
        isDisabled: isDisabled,
        cabinId: cabinId,
        recurringBookingId: id,
      );

  List<Booking> get bookings {
    var runningBookings = <Booking>[];
    var runningDateTime = dateStart;
    var movedBooking = booking;

    var count = 1;

    while (runningDateTime.isBefore(until)) {
      runningBookings.add(
        movedBooking
          ..id = '$id-$count'
          ..recurringBookingId = id
          ..recurringNumber = count
          ..recurringTotalTimes = times,
      );

      runningDateTime = runningDateTime.add(periodicity);

      if (runningDateTime.isBefore(until)) {
        movedBooking = movedBooking.movedTo(runningDateTime);
        count++;
      }
    }

    return runningBookings;
  }

  Booking bookingOn(DateTime dateTime) => bookings.firstWhere(
        (booking) => booking.isOn(dateTime),
        orElse: () => null,
      );

  bool hasBookingOn(DateTime dateTime) => bookingOn(dateTime) != null;

  void replaceRecurringWith(RecurringBooking recurringBooking) {
    periodicity = recurringBooking.periodicity;
    _until = recurringBooking.until;
    _times = recurringBooking.times;

    super.replaceWith(recurringBooking);
  }

  @override
  String toString() => '$times × ${super.toString()}';
}

enum RecurringBookingMethod {
  until,
  times,
}
