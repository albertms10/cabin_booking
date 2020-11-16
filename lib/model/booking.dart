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

  Booking.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        studentName = json['studentName'],
        dateStart = json['dateStart'],
        dateEnd = json['dateEnd'];

  Map<String, dynamic> get toJson => {
        'id': id,
        'studentName': studentName,
        'dateStart': dateStart,
        'dateEnd': dateEnd,
      };

  Duration get duration => dateEnd.difference(dateStart);

  String get dateRange =>
      '${DateFormat('HH:mm').format(dateStart)}–${DateFormat('HH:mm').format(dateEnd)}';

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
