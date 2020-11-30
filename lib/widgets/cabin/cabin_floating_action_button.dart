import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:cabin_booking/model/cabin.dart';
import 'package:cabin_booking/model/cabin_manager.dart';
import 'package:cabin_booking/widgets/cabin/cabin_dialog.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CabinFloatingActionButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final cabinManager = Provider.of<CabinManager>(context, listen: false);

    return FloatingActionButton(
      onPressed: () async {
        final newCabin = await showDialog<Cabin>(
          context: context,
          builder: (context) => CabinDialog(
            Cabin(),
            newCabinNumber: cabinManager.lastCabinNumber + 1,
          ),
        );

        if (newCabin != null) {
          cabinManager.addCabin(newCabin);
        }
      },
      tooltip: AppLocalizations.of(context).cabin,
      child: const Icon(Icons.sensor_door_outlined),
    );
  }
}
