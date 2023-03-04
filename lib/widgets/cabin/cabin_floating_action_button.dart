import 'package:cabin_booking/model.dart';
import 'package:cabin_booking/widgets/cabin/cabin_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

class CabinFloatingActionButton extends StatelessWidget {
  const CabinFloatingActionButton({super.key});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      tooltip: AppLocalizations.of(context)!.cabin,
      onPressed: () async {
        final cabinCollection =
            Provider.of<CabinCollection>(context, listen: false);

        final newCabin = await showDialog<Cabin>(
          context: context,
          builder: (context) => CabinDialog(
            cabin: Cabin(),
            newCabinNumber: cabinCollection.lastCabinNumber + 1,
          ),
        );

        if (newCabin != null) {
          cabinCollection.addCabin(newCabin);
        }
      },
      child: const Icon(Icons.sensor_door_outlined),
    );
  }
}
