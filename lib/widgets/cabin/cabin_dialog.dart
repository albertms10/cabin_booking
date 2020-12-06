import 'package:cabin_booking/model/cabin.dart';
import 'package:cabin_booking/widgets/cabin/cabin_form.dart';
import 'package:cabin_booking/widgets/layout/data_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class CabinDialog extends StatelessWidget {
  final Cabin cabin;
  final int newCabinNumber;

  CabinDialog(this.cabin, {this.newCabinNumber});

  @override
  Widget build(BuildContext context) {
    return DataDialog(
      title: Text(
        AppLocalizations.of(context).cabin,
      ),
      content: SizedBox(
        width: 500.0,
        child: CabinForm(
          cabin: cabin,
          newCabinNumber: newCabinNumber,
        ),
      ),
    );
  }
}
