import 'package:cabin_booking/utils/time_of_day.dart';
import 'package:intl/intl.dart';

class Booking {
  String id;
  String studentName;
  DateTime dateStart;
  DateTime dateEnd;
  String cabinId;

  Booking({
    this.id,
    this.studentName,
    this.dateStart,
    this.dateEnd,
    this.cabinId,
  });

  Booking.from(Map<String, dynamic> other)
      : id = other['id'],
        studentName = other['studentName'],
        dateStart = DateTime.tryParse(other['dateStart']),
        dateEnd = DateTime.tryParse(other['dateEnd']);

  Map<String, dynamic> toMap() => {
        'id': id,
        'studentName': studentName,
        'dateStart': dateStart.toIso8601String(),
        'dateEnd': dateEnd.toIso8601String(),
      };

  Duration get duration => dateEnd.difference(dateStart);

  String get timeRange =>
      '${DateFormat('HH:mm').format(dateStart)}–${DateFormat('HH:mm').format(dateEnd)}';

  String get dateRange => '${DateFormat.yMd().format(dateStart)} $timeRange';

  bool isOn(DateTime dateTime) =>
      dateStart.year == dateTime.year &&
      dateStart.month == dateTime.month &&
      dateStart.day == dateTime.day;

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
      );

  void replaceWith(Booking booking) {
    studentName = booking.studentName;
    dateStart = booking.dateStart;
    dateEnd = booking.dateEnd;
  }

  @override
  String toString() => '$studentName $dateRange';

  @override
  bool operator ==(other) => other is Booking && this.id == other.id;

  @override
  int get hashCode => id.hashCode;
}
