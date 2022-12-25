import 'package:flutter/foundation.dart' show immutable;

import 'date_range.dart';

abstract class _JsonFields {
  static const kind = 'k';
}

@immutable
class Holiday extends DateRange {
  final HolidayKind kind;

  const Holiday({
    super.startDate,
    super.endDate,
    required this.kind,
  });

  Holiday.fromJson(super.other)
      : kind = HolidayKind.values[other[_JsonFields.kind] as int],
        super.fromJson();

  @override
  Map<String, dynamic> toJson() => {
        ...super.toJson(),
        _JsonFields.kind: kind.index,
      };

  @override
  bool operator ==(Object other) =>
      super == other && other is Holiday && kind == other.kind;

  @override
  int get hashCode => Object.hash(super.hashCode, kind.hashCode);
}

enum HolidayKind { festivity, freeDisposal }
