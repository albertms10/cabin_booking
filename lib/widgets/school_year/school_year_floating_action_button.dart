import 'package:cabin_booking/model.dart';
import 'package:cabin_booking/widgets/school_year/school_year_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

class SchoolYearFloatingActionButton extends StatelessWidget {
  const SchoolYearFloatingActionButton({super.key});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      tooltip: AppLocalizations.of(context)!.schoolYear,
      onPressed: () async {
        final schoolYearCollection =
            Provider.of<DayHandler>(context, listen: false)
                .schoolYearCollection;

        final newSchoolYear = await showDialog<SchoolYear>(
          context: context,
          builder: (context) => SchoolYearDialog(schoolYear: SchoolYear()),
        );

        if (newSchoolYear != null) {
          schoolYearCollection.addSchoolYear(newSchoolYear);
        }
      },
      child: const Icon(Icons.school_outlined),
    );
  }
}
