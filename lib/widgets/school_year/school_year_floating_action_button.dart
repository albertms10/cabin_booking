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
      onPressed: () async {
        final schoolYearManager =
            Provider.of<DayHandler>(context, listen: false).schoolYearManager;

        final newSchoolYear = await showDialog<SchoolYear>(
          context: context,
          builder: (context) => SchoolYearDialog(schoolYear: SchoolYear()),
        );

        if (newSchoolYear != null) {
          schoolYearManager.addSchoolYear(newSchoolYear);
        }
      },
      tooltip: AppLocalizations.of(context)!.schoolYear,
      child: Icon(
        Icons.school_outlined,
        color: Theme.of(context).colorScheme.onPrimary,
      ),
    );
  }
}
