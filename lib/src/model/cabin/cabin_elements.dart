import 'package:collection/collection.dart';

import '../serializable.dart';
import 'piano.dart';

abstract class _JsonFields {
  static const pianos = 'p';
  static const lecterns = 'l';
  static const chairs = 'c';
  static const tables = 't';
}

/// The elements of a cabin.
class CabinElements implements Serializable {
  final List<Piano> pianos;
  int lecterns;
  int chairs;
  int tables;

  /// Creates a new [CabinElements].
  CabinElements({
    this.pianos = const [],
    this.lecterns = 0,
    this.chairs = 0,
    this.tables = 0,
  });

  /// Creates a new [CabinElements] from a JSON Map.
  CabinElements.fromJson(Map<String, dynamic> other)
      : pianos = (other[_JsonFields.pianos] as List<dynamic>)
            .cast<Map<String, dynamic>>()
            .map(Piano.fromJson)
            .toList(),
        lecterns = other[_JsonFields.lecterns] as int,
        chairs = other[_JsonFields.chairs] as int,
        tables = other[_JsonFields.tables] as int;

  @override
  Map<String, dynamic> toJson() => {
        _JsonFields.pianos: pianos.map((piano) => piano.toJson()).toList(),
        _JsonFields.lecterns: lecterns,
        _JsonFields.chairs: chairs,
        _JsonFields.tables: tables,
      };

  @override
  bool operator ==(Object other) =>
      other is CabinElements &&
      const ListEquality<Piano>().equals(pianos, other.pianos) &&
      lecterns == other.lecterns &&
      chairs == other.chairs &&
      tables == other.tables;

  @override
  int get hashCode =>
      Object.hash(Object.hashAllUnordered(pianos), lecterns, chairs, tables);
}
