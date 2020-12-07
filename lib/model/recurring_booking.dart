import 'package:cabin_booking/model/booking.dart';

class RecurringBooking extends Booking {
  Periodicity periodicity;
  int repeatEvery;
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
    this.periodicity = Periodicity.Weekly,
    this.repeatEvery = 1,
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
      : periodicity = Periodicity.values[other['periodicityIndex']],
        repeatEvery = other['repeatEvery'],
        _endDate = other.containsKey('endDate')
            ? DateTime.tryParse(other['endDate'])
            : null,
        _occurrences =
            other.containsKey('occurrences') ? other['occurrences'] : null,
        super.from(other);

  RecurringBooking.fromBooking(Booking booking)
      : periodicity = Periodicity.Weekly,
        repeatEvery = 1,
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
        'periodicityIndex': periodicity.index,
        'repeatEvery': repeatEvery,
        if (method == RecurringBookingMethod.EndDate)
          'endDate': _endDate.toIso8601String()
        else if (method == RecurringBookingMethod.Occurrences)
          'occurrences': _occurrences,
      };

  RecurringBookingMethod get method => _endDate != null
      ? RecurringBookingMethod.EndDate
      : RecurringBookingMethod.Occurrences;

  Duration get periodicityDuration => Duration(
        days: PeriodicityValues.periodicityInDays[periodicity] * repeatEvery,
      );

  DateTime get endDate {
    if (_endDate != null) return _endDate;

    assert(_occurrences != null);

    var recurringDateTime = dateStart;

    for (var i = 0; i <= _occurrences; i++) {
      recurringDateTime = recurringDateTime.add(periodicityDuration);
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
      recurringDateTime = recurringDateTime.add(periodicityDuration);
      count++;
    }

    return count;
  }

  set occurrences(int occurrences) {
    _occurrences = occurrences;
    _endDate = null;
  }

  Booking asBooking() => Booking(
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
    var movedBooking = asBooking();

    var count = 0;

    while (runningDateTime.isBefore(endDate)) {
      runningBookings.add(
        movedBooking
          ..id = '$id-$count'
          ..recurringBookingId = id
          ..recurringNumber = count
          ..recurringTotalTimes = occurrences,
      );

      runningDateTime = runningDateTime.add(periodicityDuration);

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

enum Periodicity {
  Daily,
  Weekly,
  Monthly,
  Annually,
}

extension PeriodicityValues on Periodicity {
  static const periodicityInDays = {
    Periodicity.Daily: 1,
    Periodicity.Weekly: 7,
    Periodicity.Monthly: 30,
    Periodicity.Annually: 365,
  };
}

enum RecurringBookingMethod {
  EndDate,
  Occurrences,
}
