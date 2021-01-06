import 'package:cabin_booking/constants.dart';
import 'package:cabin_booking/model/cabin_manager.dart';
import 'package:cabin_booking/model/day_handler.dart';
import 'package:cabin_booking/model/school_year.dart';
import 'package:cabin_booking/utils/compactize_range.dart';
import 'package:cabin_booking/widgets/item/items_table.dart';
import 'package:cabin_booking/widgets/school_year/school_year_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

class SchoolYearsTable extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer2<DayHandler, CabinManager>(
      builder: (context, dayHandler, cabinManager, child) {
        final appLocalizations = AppLocalizations.of(context);

        return ItemsTable(
          itemTitle: (row) => '${row.item}',
          itemIcon: Icons.school,
          itemHeaderLabel: appLocalizations.schoolYear,
          emptyMessage: appLocalizations.noSchoolYearsMessage,
          onEditPressed: (selectedRows) async {
            final selectedSchoolYear = selectedRows.first;

            final editedSchoolYear = await showDialog<SchoolYear>(
              context: context,
              builder: (context) => SchoolYearDialog(
                schoolYear: selectedSchoolYear.item,
              ),
            );

            if (editedSchoolYear != null) {
              dayHandler.schoolYearManager.modifySchoolYear(editedSchoolYear);
            }
          },
          rows: [
            for (final schoolYear in dayHandler.schoolYearManager.schoolYears)
              ItemsTableRow<SchoolYear>(
                item: schoolYear,
                bookingsCount: cabinManager.bookingsCountBetween(schoolYear),
                recurringBookingsCount:
                    cabinManager.recurringBookingsCountBetween(schoolYear),
                accumulatedDuration:
                    cabinManager.totalOccupiedDuration(dateRange: schoolYear),
                occupancyPercent: cabinManager.occupancyPercent(
                  startTime: kTimeTableStartTime,
                  endTime: kTimeTableEndTime,
                  dates: cabinManager.allCabinsDatesWithBookings(schoolYear),
                ),
                mostOccupiedTimeRanges: compactizeRange<TimeOfDay>(
                  cabinManager.mostOccupiedTimeRange(schoolYear),
                  nextValue: (timeOfDay) => timeOfDay.replacing(
                    hour: (timeOfDay.hour + 1) % TimeOfDay.hoursPerDay,
                  ),
                  inclusive: true,
                ),
              ),
          ],
        );
      },
    );
  }
}
