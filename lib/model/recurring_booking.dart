import 'package:cabin_booking/model/booking.dart';

class RecurringBooking extends Booking {
  Duration periodicity;
  DateTime _endDate;
  int _occurrences;

  RecurringBooking({
    id,
    studentName,
    date,
    timeStart,
    timeEnd,
    isDisabled = false,
    cabinId,
    this.periodicity = const Duration(days: 7),
    endDate,
    occurrences,
  })  : assert((endDate == null) != (occurrences == null)),
        _endDate = endDate,
        _occurrences = occurrences,
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
        _endDate = other.containsKey('endDate')
            ? DateTime.tryParse(other['endDate'])
            : null,
        _occurrences =
            other.containsKey('occurrences') ? other['occurrences'] : null,
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
        if (method == RecurringBookingMethod.endDate)
          'endDate': _endDate.toIso8601String(),
        if (method == RecurringBookingMethod.occurrences)
          'occurrences': _occurrences,
      };

  RecurringBookingMethod get method => _endDate != null
      ? RecurringBookingMethod.endDate
      : RecurringBookingMethod.occurrences;

  DateTime get endDate {
    if (_endDate != null) return _endDate;

    assert(_occurrences != null);

    var recurringDateTime = dateStart;

    for (var i = 0; i < _occurrences; i++) {
      recurringDateTime = recurringDateTime.add(periodicity);
    }

    return recurringDateTime;
  }

  set endDate(DateTime endDate) {
    _endDate = endDate;
    _occurrences = null;
  }

  int get occurrences {
    if (_occurrences != null) return _occurrences;

    assert(_endDate != null);

    var count = 0;
    var recurringDateTime = dateStart;

    while (recurringDateTime.isBefore(_endDate)) {
      recurringDateTime = recurringDateTime.add(periodicity);
      count++;
    }

    return count;
  }

  set occurrences(int occurrences) {
    _occurrences = occurrences;
    _endDate = null;
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

    var count = 0;

    while (runningDateTime.isBefore(endDate)) {
      runningBookings.add(
        movedBooking
          ..id = '$id-$count'
          ..recurringBookingId = id
          ..recurringNumber = count
          ..recurringTotalTimes = occurrences,
      );

      runningDateTime = runningDateTime.add(periodicity);

      if (runningDateTime.isBefore(endDate)) {
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
    _endDate = recurringBooking._endDate;
    _occurrences = recurringBooking._occurrences;

    super.replaceWith(recurringBooking);
  }

  @override
  String toString() => '$occurrences × ${super.toString()}';
}

enum RecurringBookingMethod {
  endDate,
  occurrences,
}
