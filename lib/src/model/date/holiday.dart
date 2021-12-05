import 'date_range.dart';

abstract class _JsonFields {
  static const kind = 'k';
}

class Holiday extends DateRange {
  final HolidayKind kind;

  Holiday({
    String? id,
    DateTime? startDate,
    DateTime? endDate,
    this.kind = HolidayKind.festivity,
  }) : super(
          id: id,
          startDate: startDate,
          endDate: endDate,
        );

  Holiday.from(Map<String, dynamic> other)
      : kind = HolidayKind.values[other[_JsonFields.kind] as int],
        super.from(other);

  @override
  Map<String, dynamic> toJson() => {
        ...super.toJson(),
        _JsonFields.kind: kind.index,
      };
}

enum HolidayKind { festivity, freeDisposal }
