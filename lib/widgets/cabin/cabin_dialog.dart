import 'package:cabin_booking/model.dart';
import 'package:cabin_booking/widgets/cabin/cabin_form.dart';
import 'package:cabin_booking/widgets/layout/data_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class CabinDialog extends StatelessWidget {
  final Cabin cabin;
  final int? newCabinNumber;

  const CabinDialog({super.key, required this.cabin, this.newCabinNumber});

  @override
  Widget build(BuildContext context) {
    return DataDialog(
      title: Text(AppLocalizations.of(context)!.cabin),
      content: SizedBox(
        width: 250.0,
        child: CabinForm(
          cabin: cabin,
          newCabinNumber: newCabinNumber,
        ),
      ),
    );
  }
}
