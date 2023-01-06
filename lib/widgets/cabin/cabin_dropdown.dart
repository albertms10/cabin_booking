import 'package:cabin_booking/model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

class CabinDropdown extends StatelessWidget {
  final String value;
  final void Function(String?)? onChanged;

  const CabinDropdown({super.key, required this.value, this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Consumer<CabinCollection>(
      builder: (context, cabinCollection, child) {
        return DropdownButtonFormField<String>(
          items: [
            for (final cabin in cabinCollection.cabins)
              DropdownMenuItem(
                value: cabin.id,
                child: Text(
                  '${AppLocalizations.of(context)!.cabin} ${cabin.number}',
                ),
              ),
          ],
          value: value,
          onChanged: onChanged,
          isExpanded: true,
        );
      },
    );
  }
}
