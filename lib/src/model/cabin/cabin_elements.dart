import 'piano.dart';

abstract class _JsonFields {
  static const pianos = 'p';
  static const lecterns = 'l';
  static const chairs = 'c';
  static const tables = 't';
}

class CabinElements {
  late List<Piano> pianos;
  int lecterns;
  int chairs;
  int tables;

  CabinElements({
    List<Piano>? pianos,
    this.lecterns = 0,
    this.chairs = 0,
    this.tables = 0,
  }) {
    this.pianos = pianos ?? <Piano>[];
  }

  CabinElements.from(Map<String, dynamic> other)
      : pianos = (other[_JsonFields.pianos] as List<dynamic>)
            .cast<Map<String, dynamic>>()
            .map(Piano.from)
            .toList(),
        lecterns = other[_JsonFields.lecterns] as int,
        chairs = other[_JsonFields.chairs] as int,
        tables = other[_JsonFields.tables] as int;

  Map<String, dynamic> toJson() => {
        _JsonFields.pianos: pianos.map((piano) => piano.toJson()).toList(),
        _JsonFields.lecterns: lecterns,
        _JsonFields.chairs: chairs,
        _JsonFields.tables: tables,
      };
}
