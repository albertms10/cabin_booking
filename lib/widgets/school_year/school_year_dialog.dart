import 'package:cabin_booking/model/school_year.dart';
import 'package:cabin_booking/widgets/layout/data_dialog.dart';
import 'package:cabin_booking/widgets/school_year/school_year_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SchoolYearDialog extends StatelessWidget {
  final SchoolYear schoolYear;

  const SchoolYearDialog({this.schoolYear});

  @override
  Widget build(BuildContext context) {
    return DataDialog(
      title: Text(
        AppLocalizations.of(context).schoolYear,
      ),
      content: SizedBox(
        width: 250.0,
        child: SchoolYearForm(schoolYear: schoolYear),
      ),
    );
  }
}
