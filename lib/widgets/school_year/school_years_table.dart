import 'package:cabin_booking/model/day_handler.dart';
import 'package:cabin_booking/model/school_year.dart';
import 'package:cabin_booking/widgets/item/items_table.dart';
import 'package:cabin_booking/widgets/school_year/school_year_dialog.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SchoolYearsTable extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<DayHandler>(
      builder: (context, dayHandler, child) {
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
              ItemsTableRow<SchoolYear>(item: schoolYear),
          ],
        );
      },
    );
  }
}
