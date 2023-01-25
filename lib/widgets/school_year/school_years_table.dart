import 'package:cabin_booking/model.dart';
import 'package:cabin_booking/utils/iterable_extension.dart';
import 'package:cabin_booking/utils/map_extension.dart';
import 'package:cabin_booking/utils/time_of_day_extension.dart';
import 'package:cabin_booking/widgets/item/items_table.dart';
import 'package:cabin_booking/widgets/school_year/school_year_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

class SchoolYearsTable extends StatelessWidget {
  const SchoolYearsTable({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer2<DayHandler, CabinCollection>(
      builder: (context, dayHandler, cabinCollection, child) {
        final appLocalizations = AppLocalizations.of(context)!;

        return ItemsTable<SchoolYear>(
          itemIcon: Icons.school,
          itemHeaderLabel: appLocalizations.schoolYear,
          rows: [
            for (final schoolYear
                in dayHandler.schoolYearCollection.schoolYears)
              ItemsTableRow<SchoolYear>(
                item: schoolYear,
                bookingsCount: cabinCollection.bookingsCountBetween(schoolYear),
                recurringBookingsCount:
                    cabinCollection.recurringBookingsCountBetween(schoolYear),
                occupiedDuration: cabinCollection.totalOccupiedDuration(
                  dateRange: schoolYear,
                ),
                occupiedDurationPerWeek:
                    cabinCollection.occupiedDurationPerWeek(schoolYear)
                      ..fillEmptyKeyValues(
                        keys: schoolYear.dateTimeList(
                          interval: const Duration(days: DateTime.daysPerWeek),
                        ),
                        ifAbsent: () => Duration.zero,
                      ),
                mostOccupiedTimeRanges: cabinCollection
                    .mostOccupiedTimeRange(schoolYear)
                    .compactConsecutive(
                      nextValue: (timeOfDay) => timeOfDay.increment(hours: 1),
                      inclusive: true,
                    )
                    .toSet(),
              ),
          ],
          emptyMessage: appLocalizations.noSchoolYearsMessage,
          shallEmpty: false,
          onEditPressed: (selectedRows) async {
            final selectedSchoolYear = selectedRows.first;
            final editedSchoolYear = await showDialog<SchoolYear>(
              context: context,
              builder: (context) =>
                  SchoolYearDialog(schoolYear: selectedSchoolYear.item),
            );

            if (editedSchoolYear != null) {
              dayHandler.schoolYearCollection
                  .modifySchoolYear(editedSchoolYear);
            }
          },
          onRemoveTitle: appLocalizations.deleteSchoolYearTitle,
          onRemovePressed: (selectedIds) => dayHandler.schoolYearCollection
              .removeSchoolYearsByIds(selectedIds),
        );
      },
    );
  }
}
