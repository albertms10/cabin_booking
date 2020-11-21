import 'package:cabin_booking/utils/time_of_day.dart';
import 'package:intl/intl.dart';

class Booking {
  String id;
  String studentName;
  DateTime dateStart;
  DateTime dateEnd;
  String cabinId;
  bool isDisabled;

  Booking({
    this.id,
    this.studentName,
    this.dateStart,
    this.dateEnd,
    this.cabinId,
    this.isDisabled = false,
  });

  Booking.from(Map<String, dynamic> other)
      : id = other['id'],
        studentName = other['studentName'],
        dateStart = DateTime.tryParse(other['dateStart']),
        dateEnd = DateTime.tryParse(other['dateEnd']),
        isDisabled = other['isDisabled'];

  Map<String, dynamic> toMap() => {
        'id': id,
        'studentName': studentName,
        'dateStart': dateStart.toIso8601String(),
        'dateEnd': dateEnd.toIso8601String(),
        'isDisabled': isDisabled,
      };

  Duration get duration => dateEnd.difference(dateStart);

  String get timeRange =>
      '${DateFormat('HH:mm').format(dateStart)}–${DateFormat('HH:mm').format(dateEnd)}';

  String get dateRange => '${DateFormat.yMd().format(dateStart)} $timeRange';

  bool isOn(DateTime dateTime) =>
      dateStart.year == dateTime.year &&
      dateStart.month == dateTime.month &&
      dateStart.day == dateTime.day;

  bool comprises(
    DateTime dateTime, {
    bool atSameMomentStart = false,
    bool atSameMomentEnd = false,
  }) =>
      (dateStart.isBefore(dateTime) ||
          (atSameMomentStart && dateStart.isAtSameMomentAs(dateTime))) &&
      (dateEnd.isAfter(dateTime) ||
          (atSameMomentEnd && dateEnd.isAtSameMomentAs(dateTime)));

  Booking movedTo(DateTime dateTime) => Booking(
        id: id,
        studentName: studentName,
        dateStart: tryParseDateTimeWithFormattedTimeOfDay(
          dateTime: dateTime,
          formattedTimeOfDay: parsedTimeOfDayFromDateTime(dateStart),
        ),
        dateEnd: tryParseDateTimeWithFormattedTimeOfDay(
          dateTime: dateTime,
          formattedTimeOfDay: parsedTimeOfDayFromDateTime(dateStart),
        ),
        cabinId: cabinId,
        isDisabled: isDisabled,
      );

  void replaceWith(Booking booking) {
    studentName = booking.studentName;
    dateStart = booking.dateStart;
    dateEnd = booking.dateEnd;
    isDisabled = booking.isDisabled;
  }

  @override
  String toString() =>
      '$studentName $dateRange ${isDisabled ? ' (disabled)' : ''}';

  @override
  bool operator ==(other) => other is Booking && this.id == other.id;

  @override
  int get hashCode => id.hashCode;
}
