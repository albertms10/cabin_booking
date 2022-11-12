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
}

enum HolidayKind { festivity, freeDisposal }
