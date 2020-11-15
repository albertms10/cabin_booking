import 'package:intl/intl.dart';

class Booking {
  final String id;
  String studentName;
  DateTime dateStart;
  DateTime dateEnd;

  Booking({
    this.id,
    this.studentName,
    this.dateStart,
    this.dateEnd,
  });

  Duration get duration => dateEnd.difference(dateStart);

  String get dateRange =>
      '${DateFormat('HH:mm').format(dateStart)}–${DateFormat('HH:mm').format(dateEnd)}';

  @override
  String toString() => '$studentName $dateRange';
}
