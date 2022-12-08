import 'date_range_item.dart';

abstract class _JsonFields {
  static const kind = 'k';
}

class Holiday extends DateRangeItem {
  final HolidayKind kind;

  Holiday({
    super.id,
    super.startDate,
    super.endDate,
    this.kind = HolidayKind.festivity,
  });

  Holiday.from(super.other)
      : kind = HolidayKind.values[other[_JsonFields.kind] as int],
        super.from();

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
