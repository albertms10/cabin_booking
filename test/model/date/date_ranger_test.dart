import 'package:cabin_booking/model.dart';
import 'package:flutter/material.dart' show TimeOfDay;
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('DateRanger', () {
    group('.startTime', () {
      test('should return the start TimeOfDay', () {
        final dateRange = DateRange(
          startDate: DateTime(2022, 12, 1, 9, 30),
          endDate: DateTime(2022, 12, 31, 21, 30),
        );
        expect(dateRange.startTime, const TimeOfDay(hour: 9, minute: 30));
      });

      test('should return null if the start date is infinite', () {
        final endDateRange = DateRange(
          endDate: DateTime(2022, 12, 31, 21, 30),
        );
        expect(endDateRange.startTime, isNull);
        expect(DateRange.infinite.startTime, isNull);
      });
    });

    group('.endTime', () {
      test('should return the end TimeOfDay', () {
        final dateRange = DateRange(
          startDate: DateTime(2022, 12, 1, 9, 30),
          endDate: DateTime(2022, 12, 31, 21, 30),
        );
        expect(dateRange.endTime, const TimeOfDay(hour: 21, minute: 30));
      });

      test('should return null if the end date is infinite', () {
        final startDateRange = DateRange(
          startDate: DateTime(2022, 12, 31, 9, 30),
        );
        expect(startDateRange.endTime, isNull);
        expect(DateRange.infinite.endTime, isNull);
      });
    });

    group('.isOn()', () {
      test(
        'should return true if this finite DateRanger happens on a DateTime',
        () {
          final dateTime = DateTime(2022, 12, 4);
          final dateRange = DateRange(
            startDate: DateTime(2022, 12, 4, 9, 45),
            endDate: DateTime(2022, 12, 5, 21, 15),
          );
          expect(dateRange.isOn(dateTime), isTrue);
        },
      );

      test(
        'should return true if this infinite DateRanger happens on a DateTime',
        () {
          final dateTime = DateTime(2022, 12, 4);
          final dateRange = DateRange(
            endDate: DateTime(2022, 12, 5, 21, 15),
          );
          expect(dateRange.isOn(dateTime), isTrue);

          final dateRange2 = DateRange(
            startDate: DateTime(2022, 12, 3, 9, 45),
          );
          expect(dateRange2.isOn(dateTime), isTrue);

          expect(DateRange.infinite.isOn(dateTime), isTrue);
        },
      );

      test(
        'should return false if this finite DateRanger does not happen on a '
        'DateTime',
        () {
          final dateTime = DateTime(2022, 12, 3);
          final dateRange = DateRange(
            startDate: DateTime(2022, 12, 4, 9, 45),
            endDate: DateTime(2022, 12, 5, 21, 15),
          );
          expect(dateRange.isOn(dateTime), isFalse);
        },
      );

      test(
        'should return false if this infinite DateRanger does not happen on a '
        'DateTime',
        () {
          final dateTime = DateTime(2022, 12, 4);

          final dateRange = DateRange(
            startDate: DateTime(2022, 12, 5, 21, 15),
          );
          expect(dateRange.isOn(dateTime), isFalse);

          final dateRange2 = DateRange(
            endDate: DateTime(2022, 12, 3, 9, 45),
          );
          expect(dateRange2.isOn(dateTime), isFalse);
        },
      );
    });

    group('.includes()', () {
      test(
        'should return true when the DateTime is included in this DateRanger',
        () {
          final startDateTime = DateTime(2022, 12, 1, 9, 30);
          final endDateTime = DateTime(2022, 12, 31, 21, 30);
          final dateRange = DateRange(
            startDate: startDateTime,
            endDate: endDateTime,
          );
          expect(dateRange.includes(startDateTime), isTrue);
          expect(dateRange.includes(endDateTime), isFalse);
          final dateTime = DateTime(2022, 12, 4, 11, 30);
          expect(dateRange.includes(dateTime), isTrue);

          final startDateRange = DateRange(startDate: startDateTime);
          expect(startDateRange.includes(dateTime), isTrue);

          final endDateRange = DateRange(endDate: endDateTime);
          expect(endDateRange.includes(dateTime), isTrue);
        },
      );

      test(
        'should return false when the DateTime is not included in this '
        'DateRanger',
        () {
          final beforeDateTime = DateTime(2022, 12, 1, 8);
          final afterDateTime = DateTime(2022, 12, 31, 21, 45);
          final dateRange = DateRange(
            startDate: DateTime(2022, 12, 1, 9, 30),
            endDate: DateTime(2022, 12, 31, 21, 30),
          );
          expect(dateRange.includes(beforeDateTime), isFalse);
          expect(dateRange.includes(afterDateTime), isFalse);

          final startDateRange = DateRange(
            startDate: DateTime(2022, 12, 1, 9, 30),
          );
          expect(startDateRange.includes(afterDateTime), isTrue);

          final endDateRange = DateRange(
            endDate: DateTime(2022, 12, 31, 21, 30),
          );
          expect(endDateRange.includes(beforeDateTime), isTrue);
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
          final dateRange1 = DateRange(
            startDate: DateTime(2022, 12, 4, 9, 15),
            endDate: DateTime(2022, 12, 4, 12, 15),
          );
          final dateRange2 = DateRange(
            startDate: DateTime(2022, 12, 4, 10, 15),
            endDate: DateTime(2022, 12, 4, 11, 15),
          );
          expect(dateRange1.overlapsWith(dateRange2), isTrue);
          expect(dateRange2.overlapsWith(dateRange1), isTrue);
        },
      );

      test(
        'should return true if this infinite DateRanger overlaps with another '
        'infinite DateRanger',
        () {
          final dateRange1 = DateRange(
            endDate: DateTime(2022, 12, 4, 12, 15),
          );
          final dateRange2 = DateRange(
            startDate: DateTime(2022, 12, 4, 10, 15),
          );
          expect(dateRange1.overlapsWith(dateRange2), isTrue);
          expect(dateRange2.overlapsWith(dateRange1), isTrue);

          expect(DateRange.infinite.overlapsWith(DateRange.infinite), isTrue);
          expect(DateRange.infinite.overlapsWith(dateRange1), isTrue);
          expect(dateRange1.overlapsWith(DateRange.infinite), isTrue);
          final dateRange3 = DateRange.fromDate(DateTime(2022, 12, 4));
          expect(DateRange.infinite.overlapsWith(dateRange3), isTrue);
          expect(dateRange3.overlapsWith(DateRange.infinite), isTrue);
        },
      );

      test(
        'should return false if this finite DateRanger does not overlap with '
        'another finite DateRanger',
        () {
          final dateRange1 = DateRange.fromDate(DateTime(2022, 12, 4));
          final dateRange2 = DateRange.fromDate(DateTime(2022, 12, 5));
          expect(dateRange1.overlapsWith(dateRange2), isFalse);
          expect(dateRange2.overlapsWith(dateRange1), isFalse);
        },
      );

      test(
        'should return false if this infinite DateRanger does not overlap with '
        'another infinite DateRanger',
        () {
          final dateRange1 = DateRange(
            startDate: DateTime(2022, 12, 4, 12, 15),
          );
          final dateRange2 = DateRange(
            endDate: DateTime(2022, 12, 4, 10, 15),
          );
          expect(dateRange1.overlapsWith(dateRange2), isFalse);
          expect(dateRange2.overlapsWith(dateRange1), isFalse);
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
        final dateRange = DateRange(
          startDate: DateTime(2022, 12, 1, 9, 30),
          endDate: DateTime(2022, 12, 31, 21, 30),
        );
        expect(dateRange.isFinite, isTrue);
      });

      test('should return false when this DateRanger is infinite', () {
        final startDateRange = DateRange(
          startDate: DateTime(2022, 12, 1, 9, 30),
        );
        expect(startDateRange.isFinite, isFalse);

        final endDateRange = DateRange(
          endDate: DateTime(2022, 12, 31, 21, 30),
        );
        expect(endDateRange.isFinite, isFalse);

        expect(DateRange.infinite.isFinite, isFalse);
      });
    });

    group('.isInfinite', () {
      test('should return true when this DateRanger is infinite', () {
        final startDateRange = DateRange(
          startDate: DateTime(2022, 12, 1, 9, 30),
        );
        expect(startDateRange.isInfinite, isTrue);

        final endDateRange = DateRange(
          endDate: DateTime(2022, 12, 31, 21, 30),
        );
        expect(endDateRange.isInfinite, isTrue);

        expect(DateRange.infinite.isInfinite, isTrue);
      });

      test('should return false when this DateRanger is finite', () {
        final dateRange = DateRange(
          startDate: DateTime(2022, 12, 1, 9, 30),
          endDate: DateTime(2022, 12, 31, 21, 30),
        );
        expect(dateRange.isInfinite, isFalse);
      });
    });

    group('.hasInfiniteStart', () {
      test('should return true when this DateRanger has an infinite start', () {
        final endDateRange = DateRange(
          endDate: DateTime(2022, 12, 31, 21, 30),
        );
        expect(endDateRange.hasInfiniteStart, isTrue);

        expect(DateRange.infinite.hasInfiniteStart, isTrue);
      });

      test('should return false when this DateRanger has a finite start', () {
        final dateRange = DateRange(
          startDate: DateTime(2022, 12, 1, 9, 30),
          endDate: DateTime(2022, 12, 31, 21, 30),
        );
        expect(dateRange.hasInfiniteStart, isFalse);

        final startDateRange = DateRange(
          startDate: DateTime(2022, 12, 1, 9, 30),
        );
        expect(startDateRange.hasInfiniteStart, isFalse);
      });
    });

    group('.hasInfiniteEnd', () {
      test('should return true when this DateRanger has an infinite end', () {
        final startDateRange = DateRange(
          startDate: DateTime(2022, 12, 1, 9, 30),
        );
        expect(startDateRange.hasInfiniteEnd, isTrue);

        expect(DateRange.infinite.hasInfiniteEnd, isTrue);
      });

      test('should return false when this DateRanger has a finite end', () {
        final dateRange = DateRange(
          startDate: DateTime(2022, 12, 1, 9, 30),
          endDate: DateTime(2022, 12, 31, 21, 30),
        );
        expect(dateRange.hasInfiniteEnd, isFalse);

        final endDateRange = DateRange(
          endDate: DateTime(2022, 12, 31, 21, 30),
        );
        expect(endDateRange.hasInfiniteEnd, isFalse);
      });
    });

    group('.duration', () {
      test('should return the Duration of a finite DateRanger', () {
        final hourDateRange = DateRange(
          startDate: DateTime(2022, 12, 4, 9, 15),
          endDate: DateTime(2022, 12, 4, 10, 15),
        );
        expect(hourDateRange.duration, const Duration(hours: 1));

        final dayDateRange = DateRange.fromDate(DateTime(2022, 12, 4));
        expect(dayDateRange.duration, const Duration(days: 1));

        final weekDateRange = DateRange(
          startDate: DateTime(2022, 12, 27),
          endDate: DateTime(2023, 1, 3),
        );
        expect(weekDateRange.duration, const Duration(days: 7));
      });

      test('should return a Duration of zero for an infinite DateRanger', () {
        final startDateRange = DateRange(
          startDate: DateTime(2022, 12, 1, 9, 30),
        );
        expect(startDateRange.duration, Duration.zero);

        final endDateRange = DateRange(
          endDate: DateTime(2022, 12, 31, 21, 30),
        );
        expect(endDateRange.duration, Duration.zero);

        expect(DateRange.infinite.duration, Duration.zero);
      });
    });

    group('.textualDateTime()', () {
      test(
        'should return a textual range representation of a finite '
        'DateRanger with the same year',
        () {
          final dateRange = DateRange(
            startDate: DateTime(2022, 12, 1, 9, 30),
            endDate: DateTime(2022, 12, 31, 21, 30),
          );
          expect(
            dateRange.textualDateTime(referenceDateTime: DateTime(2022)),
            'December 1 09:30 – December 31 21:30',
          );
          expect(
            dateRange.textualDateTime(referenceDateTime: DateTime(2023)),
            'December 1, 2022 09:30 – December 31 21:30',
          );
          expect(
            dateRange.textualDateTime(referenceDateTime: DateTime(2023)),
            dateRange.textualDateTime(referenceDateTime: DateTime(2021)),
          );
          expect(
            dateRange.textualDateTime(
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
          final dateRange = DateRange(
            startDate: DateTime(2022, 12, 1, 9, 30),
            endDate: DateTime(2022, 12, 1, 21, 30),
          );
          expect(
            dateRange.textualDateTime(referenceDateTime: DateTime(2022)),
            'December 1 09:30–21:30',
          );
          expect(
            dateRange.textualDateTime(referenceDateTime: DateTime(2023)),
            'December 1, 2022 09:30–21:30',
          );
          expect(
            dateRange.textualDateTime(referenceDateTime: DateTime(2023)),
            dateRange.textualDateTime(referenceDateTime: DateTime(2021)),
          );
          expect(
            dateRange.textualDateTime(
              referenceDateTime: DateTime(2022),
              monthDayFormat: (format) => format.add_d().add_LLL(),
              timeFormat: (format) => format.add_Hms(),
            ),
            '1 Dec 09:30:00–21:30:00',
          );
          expect(
            dateRange.textualDateTime(
              referenceDateTime: DateTime(2022),
              monthDayFormat: (format) => format.add_MMMMEEEEd(),
            ),
            'Thursday, December 1 09:30–21:30',
          );
          expect(
            dateRange.textualDateTime(
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
          final dateRange = DateRange(
            startDate: DateTime(2022, 12, 1, 9, 30),
            endDate: DateTime(2023, 1, 12, 21, 30),
          );
          expect(
            dateRange.textualDateTime(referenceDateTime: DateTime(2022)),
            'December 1, 2022 09:30 – January 12, 2023 21:30',
          );
          expect(
            dateRange.textualDateTime(
              fullDateFormat: (format) => format.add_yMd(),
            ),
            '12/1/2022 09:30 – 1/12/2023 21:30',
          );
          expect(
            dateRange.textualDateTime(
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
          final startDateRange = DateRange(
            startDate: DateTime(2022, 12, 1, 9, 30),
          );
          expect(
            startDateRange.textualDateTime(),
            'December 1, 2022 09:30 – null',
          );

          final endDateRange = DateRange(
            endDate: DateTime(2022, 12, 31, 21, 30),
          );
          expect(
            endDateRange.textualDateTime(),
            'null – December 31, 2022 21:30',
          );

          expect(DateRange.infinite.textualDateTime(), 'null – null');
        },
      );
    });

    group('.textualTime', () {
      test('should return the textual time range of a finite DateRanger', () {
        final dateRange = DateRange(
          startDate: DateTime(2022, 12, 1, 9, 30),
          endDate: DateTime(2022, 12, 1, 21, 30),
        );
        expect(dateRange.textualTime, '09:30–21:30');

        final multiYearDateRange = DateRange(
          startDate: DateTime(2022, 12, 1, 9, 30),
          endDate: DateTime(2023, 1, 12, 21, 30),
        );
        expect(multiYearDateRange.textualTime, '09:30–21:30');
      });

      test(
        'should return the textual local time range of a UTC DateRanger',
        () {
          final dateRange = DateRange(
            startDate: DateTime.utc(2022, 12, 1, 9, 30),
            endDate: DateTime.utc(2022, 12, 1, 21, 45),
          );
          final startDate = dateRange.startDate!.toLocal();
          final endDate = dateRange.endDate!.toLocal();
          String padTime(int time) => '$time'.padLeft(2, '0');
          expect(
            dateRange.textualTime,
            '${padTime(startDate.hour)}:${padTime(startDate.minute)}–'
            '${padTime(endDate.hour)}:${padTime(endDate.minute)}',
          );
        },
      );

      test(
        'should return the textual time range of an infinite DateRanger',
        () {
          final dateRange = DateRange(
            startDate: DateTime(2022, 12, 1, 9, 30),
          );
          expect(dateRange.textualTime, '09:30 – null');

          final multiYearDateRange = DateRange(
            endDate: DateTime(2023, 1, 12, 21, 30),
          );
          expect(multiYearDateRange.textualTime, 'null – 21:30');

          expect(DateRange.infinite.textualTime, 'null – null');
        },
      );
    });

    group('.hoursSpan', () {
      test('should return a Map of the time span of this DateRanger', () {
        final dateRange = DateRange(
          startDate: DateTime(2022, 12, 4, 9, 30),
          endDate: DateTime(2022, 12, 4, 13, 15),
        );
        expect(dateRange.hoursSpan, {
          const TimeOfDay(hour: 09, minute: 0): const Duration(minutes: 30),
          const TimeOfDay(hour: 10, minute: 0): const Duration(hours: 1),
          const TimeOfDay(hour: 11, minute: 0): const Duration(hours: 1),
          const TimeOfDay(hour: 12, minute: 0): const Duration(hours: 1),
          const TimeOfDay(hour: 13, minute: 0): const Duration(minutes: 15),
        });
      });

      test('should return an empty Map for an instant DateRanger', () {
        final dateTime = DateTime(2022, 12, 4);
        final instantDateRange =
            DateRange(startDate: dateTime, endDate: dateTime);
        expect(instantDateRange.hoursSpan, const <TimeOfDay, Duration>{});
      });

      test('should return an empty Map for an infinite DateRanger', () {
        final startDateRange = DateRange(
          startDate: DateTime(2022, 12, 1, 9, 30),
        );
        expect(startDateRange.hoursSpan, const <TimeOfDay, Duration>{});

        final endDateRange = DateRange(
          endDate: DateTime(2022, 12, 31, 21, 30),
        );
        expect(endDateRange.hoursSpan, const <TimeOfDay, Duration>{});

        expect(DateRange.infinite.hoursSpan, const <TimeOfDay, Duration>{});
      });
    });

    group('.dateTimeList()', () {
      test('should return a DateTime list included in this DateRanger', () {
        final dateRange = DateRange.fromDate(DateTime(2022, 12, 4));
        expect(dateRange.dateTimeList(interval: const Duration(hours: 8)), [
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
