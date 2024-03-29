import 'package:cabin_booking/model.dart';
import 'package:flutter/material.dart' show TimeOfDay;
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('DateRanger', () {
    group('.startTime', () {
      test('should return the start TimeOfDay', () {
        final DateRanger dateRanger = DateRange(
          startDate: DateTime(2022, 12, 1, 9, 30),
          endDate: DateTime(2022, 12, 31, 21, 30),
        );
        expect(dateRanger.startTime, const TimeOfDay(hour: 9, minute: 30));
      });

      test('should return null if the start date is infinite', () {
        final DateRanger endDateRanger = DateRange(
          endDate: DateTime(2022, 12, 31, 21, 30),
        );
        expect(endDateRanger.startTime, isNull);
        expect(DateRange.infinite.startTime, isNull);
      });
    });

    group('.endTime', () {
      test('should return the end TimeOfDay', () {
        final DateRanger dateRanger = DateRange(
          startDate: DateTime(2022, 12, 1, 9, 30),
          endDate: DateTime(2022, 12, 31, 21, 30),
        );
        expect(dateRanger.endTime, const TimeOfDay(hour: 21, minute: 30));
      });

      test('should return null if the end date is infinite', () {
        final DateRanger startDateRanger = DateRange(
          startDate: DateTime(2022, 12, 31, 9, 30),
        );
        expect(startDateRanger.endTime, isNull);
        expect(DateRange.infinite.endTime, isNull);
      });
    });

    group('.isOn()', () {
      test(
        'should return true if this finite DateRanger happens on a DateTime',
        () {
          final dateTime = DateTime(2022, 12, 4);
          final DateRanger dateRanger = DateRange(
            startDate: DateTime(2022, 12, 4, 9, 45),
            endDate: DateTime(2022, 12, 5, 21, 15),
          );
          expect(dateRanger.isOn(dateTime), isTrue);
        },
      );

      test(
        'should return true if this infinite DateRanger happens on a DateTime',
        () {
          final dateTime = DateTime(2022, 12, 4);
          final DateRanger dateRanger = DateRange(
            endDate: DateTime(2022, 12, 5, 21, 15),
          );
          expect(dateRanger.isOn(dateTime), isTrue);

          final DateRanger dateRanger2 = DateRange(
            startDate: DateTime(2022, 12, 3, 9, 45),
          );
          expect(dateRanger2.isOn(dateTime), isTrue);

          expect(DateRange.infinite.isOn(dateTime), isTrue);
        },
      );

      test(
        'should return false if this finite DateRanger does not happen on a '
        'DateTime',
        () {
          final dateTime = DateTime(2022, 12, 3);
          final DateRanger dateRanger = DateRange(
            startDate: DateTime(2022, 12, 4, 9, 45),
            endDate: DateTime(2022, 12, 5, 21, 15),
          );
          expect(dateRanger.isOn(dateTime), isFalse);
        },
      );

      test(
        'should return false if this infinite DateRanger does not happen on a '
        'DateTime',
        () {
          final dateTime = DateTime(2022, 12, 4);

          final DateRanger dateRanger = DateRange(
            startDate: DateTime(2022, 12, 5, 21, 15),
          );
          expect(dateRanger.isOn(dateTime), isFalse);

          final DateRanger dateRanger2 = DateRange(
            endDate: DateTime(2022, 12, 3, 9, 45),
          );
          expect(dateRanger2.isOn(dateTime), isFalse);
        },
      );
    });

    group('.includes()', () {
      test(
        'should return true when the DateTime is included in this DateRanger',
        () {
          final startDateTime = DateTime(2022, 12, 1, 9, 30);
          final endDateTime = DateTime(2022, 12, 31, 21, 30);
          final DateRanger dateRanger = DateRange(
            startDate: startDateTime,
            endDate: endDateTime,
          );
          expect(dateRanger.includes(startDateTime), isTrue);
          expect(dateRanger.includes(endDateTime), isFalse);
          final dateTime = DateTime(2022, 12, 4, 11, 30);
          expect(dateRanger.includes(dateTime), isTrue);

          final DateRanger startDateRanger =
              DateRange(startDate: startDateTime);
          expect(startDateRanger.includes(dateTime), isTrue);

          final DateRanger endDateRanger = DateRange(endDate: endDateTime);
          expect(endDateRanger.includes(dateTime), isTrue);
        },
      );

      test(
        'should return false when the DateTime is not included in this '
        'DateRanger',
        () {
          final beforeDateTime = DateTime(2022, 12, 1, 8);
          final afterDateTime = DateTime(2022, 12, 31, 21, 45);
          final DateRanger dateRanger = DateRange(
            startDate: DateTime(2022, 12, 1, 9, 30),
            endDate: DateTime(2022, 12, 31, 21, 30),
          );
          expect(dateRanger.includes(beforeDateTime), isFalse);
          expect(dateRanger.includes(afterDateTime), isFalse);

          final DateRanger startDateRanger = DateRange(
            startDate: DateTime(2022, 12, 1, 9, 30),
          );
          expect(startDateRanger.includes(afterDateTime), isTrue);

          final DateRanger endDateRanger = DateRange(
            endDate: DateTime(2022, 12, 31, 21, 30),
          );
          expect(endDateRanger.includes(beforeDateTime), isTrue);
        },
      );

      test('should return true when this DateRanger is infinite', () {
        final dateTime = DateTime(2022, 12, 4, 11, 30);
        expect(DateRange.infinite.includes(dateTime), isTrue);
      });
    });

    group('.overlapsWith()', () {
      test(
        'should return true if this finite DateRanger overlaps with another '
        'finite DateRanger',
        () {
          final DateRanger dateRanger1 = DateRange(
            startDate: DateTime(2022, 12, 4, 9, 15),
            endDate: DateTime(2022, 12, 4, 12, 15),
          );
          final DateRanger dateRanger2 = DateRange(
            startDate: DateTime(2022, 12, 4, 10, 15),
            endDate: DateTime(2022, 12, 4, 11, 15),
          );
          expect(dateRanger1.overlapsWith(dateRanger2), isTrue);
          expect(dateRanger2.overlapsWith(dateRanger1), isTrue);
        },
      );

      test(
        'should return true if this infinite DateRanger overlaps with another '
        'infinite DateRanger',
        () {
          final DateRanger dateRanger1 = DateRange(
            endDate: DateTime(2022, 12, 4, 12, 15),
          );
          final DateRanger dateRanger2 = DateRange(
            startDate: DateTime(2022, 12, 4, 10, 15),
          );
          expect(dateRanger1.overlapsWith(dateRanger2), isTrue);
          expect(dateRanger2.overlapsWith(dateRanger1), isTrue);

          expect(DateRange.infinite.overlapsWith(DateRange.infinite), isTrue);
          expect(DateRange.infinite.overlapsWith(dateRanger1), isTrue);
          expect(dateRanger1.overlapsWith(DateRange.infinite), isTrue);
          final DateRanger dateRanger3 =
              DateRange.fromDate(DateTime(2022, 12, 4));
          expect(DateRange.infinite.overlapsWith(dateRanger3), isTrue);
          expect(dateRanger3.overlapsWith(DateRange.infinite), isTrue);
        },
      );

      test(
        'should return false if this finite DateRanger does not overlap with '
        'another finite DateRanger',
        () {
          final DateRanger dateRanger1 =
              DateRange.fromDate(DateTime(2022, 12, 4));
          final DateRanger dateRanger2 =
              DateRange.fromDate(DateTime(2022, 12, 5));
          expect(dateRanger1.overlapsWith(dateRanger2), isFalse);
          expect(dateRanger2.overlapsWith(dateRanger1), isFalse);
        },
      );

      test(
        'should return false if this infinite DateRanger does not overlap with '
        'another infinite DateRanger',
        () {
          final DateRanger dateRanger1 = DateRange(
            startDate: DateTime(2022, 12, 4, 12, 15),
          );
          final DateRanger dateRanger2 = DateRange(
            endDate: DateTime(2022, 12, 4, 10, 15),
          );
          expect(dateRanger1.overlapsWith(dateRanger2), isFalse);
          expect(dateRanger2.overlapsWith(dateRanger1), isFalse);
        },
      );
    });

    group('.overlappingDurationWith()', () {
      test(
        'should return the inner overlapping Duration with another DateRanger',
        () {
          final DateRanger dateRanger1 = DateRange(
            startDate: DateTime(2022, 12, 4, 9, 15),
            endDate: DateTime(2022, 12, 4, 12, 15),
          );
          final DateRanger dateRanger2 = DateRange(
            startDate: DateTime(2022, 12, 4, 10),
            endDate: DateTime(2022, 12, 4, 11),
          );
          expect(
            dateRanger1.overlappingDurationWith(dateRanger2),
            const Duration(hours: 1),
          );
          expect(
            dateRanger2.overlappingDurationWith(dateRanger1),
            const Duration(hours: 1),
          );
        },
      );

      test(
        'should return the overlapping Duration between infinite DateRangers',
        () {
          final dateRange1 = DateRange(
            endDate: DateTime(2022, 12, 4, 12, 15),
          );
          final dateRange2 = DateRange(
            startDate: DateTime(2022, 12, 4, 10, 15),
          );
          expect(
            dateRange1.overlappingDurationWith(dateRange2),
            const Duration(hours: 2),
          );
          expect(
            dateRange2.overlappingDurationWith(dateRange1),
            const Duration(hours: 2),
          );
          expect(
            DateRange.infinite.overlappingDurationWith(DateRange.infinite),
            Duration.zero,
          );
          expect(
            DateRange.infinite.overlappingDurationWith(dateRange1),
            Duration.zero,
          );
          expect(
            dateRange1.overlappingDurationWith(DateRange.infinite),
            Duration.zero,
          );
          final dateRange3 = DateRange.fromDate(DateTime(2022, 12, 4));
          expect(
            DateRange.infinite.overlappingDurationWith(dateRange3),
            const Duration(days: 1),
          );
          expect(
            dateRange3.overlappingDurationWith(DateRange.infinite),
            const Duration(days: 1),
          );
        },
      );

      test(
        'should return a Duration of zero if this finite DateRanger does not '
        'overlap with another finite DateRanger',
        () {
          final dateRange1 = DateRange.fromDate(DateTime(2022, 12, 4));
          final dateRange2 = DateRange.fromDate(DateTime(2022, 12, 5));
          expect(dateRange1.overlappingDurationWith(dateRange2), Duration.zero);
          expect(dateRange2.overlappingDurationWith(dateRange1), Duration.zero);
        },
      );

      test(
        'should return a Duration of zero if this infinite DateRanger does not '
        'overlap with another infinite DateRanger',
        () {
          final dateRange1 = DateRange(
            startDate: DateTime(2022, 12, 4, 12, 15),
          );
          final dateRange2 = DateRange(
            endDate: DateTime(2022, 12, 4, 10, 15),
          );
          expect(dateRange1.overlappingDurationWith(dateRange2), Duration.zero);
          expect(dateRange2.overlappingDurationWith(dateRange1), Duration.zero);
        },
      );
    });

    group('.isFinite', () {
      test('should return true when this DateRanger is finite', () {
        final DateRanger dateRanger = DateRange(
          startDate: DateTime(2022, 12, 1, 9, 30),
          endDate: DateTime(2022, 12, 31, 21, 30),
        );
        expect(dateRanger.isFinite, isTrue);
      });

      test('should return false when this DateRanger is infinite', () {
        final DateRanger startDateRanger = DateRange(
          startDate: DateTime(2022, 12, 1, 9, 30),
        );
        expect(startDateRanger.isFinite, isFalse);

        final DateRanger endDateRanger = DateRange(
          endDate: DateTime(2022, 12, 31, 21, 30),
        );
        expect(endDateRanger.isFinite, isFalse);

        expect(DateRange.infinite.isFinite, isFalse);
      });
    });

    group('.isInfinite', () {
      test('should return true when this DateRanger is infinite', () {
        final DateRanger startDateRanger = DateRange(
          startDate: DateTime(2022, 12, 1, 9, 30),
        );
        expect(startDateRanger.isInfinite, isTrue);

        final DateRanger endDateRanger = DateRange(
          endDate: DateTime(2022, 12, 31, 21, 30),
        );
        expect(endDateRanger.isInfinite, isTrue);

        expect(DateRange.infinite.isInfinite, isTrue);
      });

      test('should return false when this DateRanger is finite', () {
        final DateRanger dateRanger = DateRange(
          startDate: DateTime(2022, 12, 1, 9, 30),
          endDate: DateTime(2022, 12, 31, 21, 30),
        );
        expect(dateRanger.isInfinite, isFalse);
      });
    });

    group('.hasInfiniteStart', () {
      test('should return true when this DateRanger has an infinite start', () {
        final DateRanger endDateRanger = DateRange(
          endDate: DateTime(2022, 12, 31, 21, 30),
        );
        expect(endDateRanger.hasInfiniteStart, isTrue);

        expect(DateRange.infinite.hasInfiniteStart, isTrue);
      });

      test('should return false when this DateRanger has a finite start', () {
        final DateRanger dateRanger = DateRange(
          startDate: DateTime(2022, 12, 1, 9, 30),
          endDate: DateTime(2022, 12, 31, 21, 30),
        );
        expect(dateRanger.hasInfiniteStart, isFalse);

        final DateRanger startDateRanger = DateRange(
          startDate: DateTime(2022, 12, 1, 9, 30),
        );
        expect(startDateRanger.hasInfiniteStart, isFalse);
      });
    });

    group('.hasInfiniteEnd', () {
      test('should return true when this DateRanger has an infinite end', () {
        final DateRanger startDateRanger = DateRange(
          startDate: DateTime(2022, 12, 1, 9, 30),
        );
        expect(startDateRanger.hasInfiniteEnd, isTrue);

        expect(DateRange.infinite.hasInfiniteEnd, isTrue);
      });

      test('should return false when this DateRanger has a finite end', () {
        final DateRanger dateRanger = DateRange(
          startDate: DateTime(2022, 12, 1, 9, 30),
          endDate: DateTime(2022, 12, 31, 21, 30),
        );
        expect(dateRanger.hasInfiniteEnd, isFalse);

        final DateRanger endDateRanger = DateRange(
          endDate: DateTime(2022, 12, 31, 21, 30),
        );
        expect(endDateRanger.hasInfiniteEnd, isFalse);
      });
    });

    group('.duration', () {
      test('should return the Duration of a finite DateRanger', () {
        final DateRanger hourDateRanger = DateRange(
          startDate: DateTime(2022, 12, 4, 9, 15),
          endDate: DateTime(2022, 12, 4, 10, 15),
        );
        expect(hourDateRanger.duration, const Duration(hours: 1));

        final DateRanger dayDateRanger =
            DateRange.fromDate(DateTime(2022, 12, 4));
        expect(dayDateRanger.duration, const Duration(days: 1));

        final DateRanger weekDateRanger = DateRange(
          startDate: DateTime(2022, 12, 27),
          endDate: DateTime(2023, 1, 3),
        );
        expect(weekDateRanger.duration, const Duration(days: 7));
      });

      test('should return a Duration of zero for an infinite DateRanger', () {
        final DateRanger startDateRanger = DateRange(
          startDate: DateTime(2022, 12, 1, 9, 30),
        );
        expect(startDateRanger.duration, Duration.zero);

        final DateRanger endDateRanger = DateRange(
          endDate: DateTime(2022, 12, 31, 21, 30),
        );
        expect(endDateRanger.duration, Duration.zero);

        expect(DateRange.infinite.duration, Duration.zero);
      });
    });

    group('.textualDateTime()', () {
      test(
        'should return a textual range representation of a finite '
        'DateRanger with the same year',
        () {
          final DateRanger dateRanger = DateRange(
            startDate: DateTime(2022, 12, 1, 9, 30),
            endDate: DateTime(2022, 12, 31, 21, 30),
          );
          expect(
            dateRanger.textualDateTime(referenceDateTime: DateTime(2022)),
            'December 1 09:30 – December 31 21:30',
          );
          expect(
            dateRanger.textualDateTime(referenceDateTime: DateTime(2023)),
            'December 1, 2022 09:30 – December 31 21:30',
          );
          expect(
            dateRanger.textualDateTime(referenceDateTime: DateTime(2023)),
            dateRanger.textualDateTime(referenceDateTime: DateTime(2021)),
          );
          expect(
            dateRanger.textualDateTime(
              referenceDateTime: DateTime(2023),
              fullDateFormat: (format) => format.add_yMMMMEEEEd(),
              monthDayFormat: (format) => format.add_LLL().add_d(),
              timeFormat: (format) => format.add_Hms(),
            ),
            'Thursday, December 1, 2022 09:30:00 – Dec 31 21:30:00',
          );
        },
      );

      test(
        'should return a textual range representation of a finite '
        'DateRanger with the same year and day',
        () {
          final DateRanger dateRanger = DateRange(
            startDate: DateTime(2022, 12, 1, 9, 30),
            endDate: DateTime(2022, 12, 1, 21, 30),
          );
          expect(
            dateRanger.textualDateTime(referenceDateTime: DateTime(2022)),
            'December 1 09:30–21:30',
          );
          expect(
            dateRanger.textualDateTime(referenceDateTime: DateTime(2023)),
            'December 1, 2022 09:30–21:30',
          );
          expect(
            dateRanger.textualDateTime(referenceDateTime: DateTime(2023)),
            dateRanger.textualDateTime(referenceDateTime: DateTime(2021)),
          );
          expect(
            dateRanger.textualDateTime(
              referenceDateTime: DateTime(2022),
              monthDayFormat: (format) => format.add_d().add_LLL(),
              timeFormat: (format) => format.add_Hms(),
            ),
            '1 Dec 09:30:00–21:30:00',
          );
          expect(
            dateRanger.textualDateTime(
              referenceDateTime: DateTime(2022),
              monthDayFormat: (format) => format.add_MMMMEEEEd(),
            ),
            'Thursday, December 1 09:30–21:30',
          );
          expect(
            dateRanger.textualDateTime(
              referenceDateTime: DateTime(2023),
              fullDateFormat: (format) => format.add_yMMMMEEEEd(),
            ),
            'Thursday, December 1, 2022 09:30–21:30',
          );
        },
      );

      test(
        'should return a textual range representation of a finite '
        'DateRanger with different years',
        () {
          final DateRanger dateRanger = DateRange(
            startDate: DateTime(2022, 12, 1, 9, 30),
            endDate: DateTime(2023, 1, 12, 21, 30),
          );
          expect(
            dateRanger.textualDateTime(referenceDateTime: DateTime(2022)),
            'December 1, 2022 09:30 – January 12, 2023 21:30',
          );
          expect(
            dateRanger.textualDateTime(
              fullDateFormat: (format) => format.add_yMd(),
            ),
            '12/1/2022 09:30 – 1/12/2023 21:30',
          );
          expect(
            dateRanger.textualDateTime(
              fullDateFormat: (format) => format.add_yMMMMEEEEd(),
            ),
            'Thursday, December 1, 2022 09:30 – '
            'Thursday, January 12, 2023 21:30',
          );
        },
      );

      test(
        'should return a textual range representation of an infinite '
        'DateRanger',
        () {
          final DateRanger startDateRanger = DateRange(
            startDate: DateTime(2022, 12, 1, 9, 30),
          );
          expect(
            startDateRanger.textualDateTime(),
            'December 1, 2022 09:30 – null',
          );

          final DateRanger endDateRanger = DateRange(
            endDate: DateTime(2022, 12, 31, 21, 30),
          );
          expect(
            endDateRanger.textualDateTime(),
            'null – December 31, 2022 21:30',
          );

          expect(DateRange.infinite.textualDateTime(), 'null – null');
        },
      );
    });

    group('.textualTime', () {
      test('should return the textual time range of a finite DateRanger', () {
        final DateRanger dateRanger = DateRange(
          startDate: DateTime(2022, 12, 1, 9, 30),
          endDate: DateTime(2022, 12, 1, 21, 30),
        );
        expect(dateRanger.textualTime, '09:30–21:30');

        final DateRanger multiYearDateRanger = DateRange(
          startDate: DateTime(2022, 12, 1, 9, 30),
          endDate: DateTime(2023, 1, 12, 21, 30),
        );
        expect(multiYearDateRanger.textualTime, '09:30–21:30');
      });

      test(
        'should return the textual local time range of a UTC DateRanger',
        () {
          final DateRanger dateRanger = DateRange(
            startDate: DateTime.utc(2022, 12, 1, 9, 30),
            endDate: DateTime.utc(2022, 12, 1, 21, 45),
          );
          final startDate = dateRanger.startDate!.toLocal();
          final endDate = dateRanger.endDate!.toLocal();
          String padTime(int time) => '$time'.padLeft(2, '0');
          expect(
            dateRanger.textualTime,
            '${padTime(startDate.hour)}:${padTime(startDate.minute)}–'
            '${padTime(endDate.hour)}:${padTime(endDate.minute)}',
          );
        },
      );

      test(
        'should return the textual time range of an infinite DateRanger',
        () {
          final DateRanger dateRanger = DateRange(
            startDate: DateTime(2022, 12, 1, 9, 30),
          );
          expect(dateRanger.textualTime, '09:30 – null');

          final DateRanger multiYearDateRanger = DateRange(
            endDate: DateTime(2023, 1, 12, 21, 30),
          );
          expect(multiYearDateRanger.textualTime, 'null – 21:30');

          expect(DateRange.infinite.textualTime, 'null – null');
        },
      );
    });

    group('.hoursSpan', () {
      test('should return a Map of the time span of this DateRanger', () {
        final DateRanger dateRanger = DateRange(
          startDate: DateTime(2022, 12, 4, 9, 30),
          endDate: DateTime(2022, 12, 4, 13, 15),
        );
        expect(dateRanger.hoursSpan, {
          const TimeOfDay(hour: 09, minute: 0): const Duration(minutes: 30),
          const TimeOfDay(hour: 10, minute: 0): const Duration(hours: 1),
          const TimeOfDay(hour: 11, minute: 0): const Duration(hours: 1),
          const TimeOfDay(hour: 12, minute: 0): const Duration(hours: 1),
          const TimeOfDay(hour: 13, minute: 0): const Duration(minutes: 15),
        });
      });

      test('should return an empty Map for an instant DateRanger', () {
        final dateTime = DateTime(2022, 12, 4);
        final DateRanger instantDateRanger =
            DateRange(startDate: dateTime, endDate: dateTime);
        expect(instantDateRanger.hoursSpan, const <TimeOfDay, Duration>{});
      });

      test('should return an empty Map for an infinite DateRanger', () {
        final DateRanger startDateRanger = DateRange(
          startDate: DateTime(2022, 12, 1, 9, 30),
        );
        expect(startDateRanger.hoursSpan, const <TimeOfDay, Duration>{});

        final DateRanger endDateRanger = DateRange(
          endDate: DateTime(2022, 12, 31, 21, 30),
        );
        expect(endDateRanger.hoursSpan, const <TimeOfDay, Duration>{});

        expect(DateRange.infinite.hoursSpan, const <TimeOfDay, Duration>{});
      });
    });

    group('.dateTimeList()', () {
      test('should return a DateTime list included in this DateRanger', () {
        final DateRanger dateRanger = DateRange.fromDate(DateTime(2022, 12, 4));
        expect(dateRanger.dateTimeList(interval: const Duration(hours: 8)), [
          DateTime(2022, 12, 4),
          DateTime(2022, 12, 4, 8),
          DateTime(2022, 12, 4, 16),
          DateTime(2022, 12, 5),
        ]);
      });

      test(
        'should return an empty DateTime list if this DateRanger is infinite',
        () {
          expect(DateRange.infinite.dateTimeList(), const <DateTime>[]);
        },
      );
    });
  });
}
