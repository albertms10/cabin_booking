import 'package:cabin_booking/model/date_range.dart';

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
      : kind = HolidayKind.values[other['kind'] as int],
        super.from(other);

  @override
  Map<String, dynamic> toJson() => {
        ...super.toJson(),
        'kind': kind.index,
      };
}

enum HolidayKind { festivity, freeDisposal }
