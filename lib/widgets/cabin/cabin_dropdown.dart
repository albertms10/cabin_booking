import 'package:cabin_booking/model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

class CabinDropdown extends StatelessWidget {
  final Cabin cabin;
  final void Function(Cabin?)? onChanged;

  const CabinDropdown({super.key, required this.cabin, this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Consumer<CabinCollection>(
      builder: (context, cabinCollection, child) {
        return DropdownButtonFormField<Cabin>(
          items: [
            for (final cabin in cabinCollection.cabins)
              DropdownMenuItem(
                value: cabin,
                child: Text(
                  '${AppLocalizations.of(context)!.cabin} ${cabin.number}',
                ),
              ),
          ],
          value: cabin,
          onChanged: onChanged,
          isExpanded: true,
        );
      },
    );
  }
}
