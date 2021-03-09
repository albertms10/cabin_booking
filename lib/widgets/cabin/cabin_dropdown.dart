import 'package:cabin_booking/model/cabin_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

class CabinDropdown extends StatelessWidget {
  final String? value;
  final void Function(String?)? onChanged;

  const CabinDropdown({
    this.value,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<CabinManager>(
      builder: (context, cabinManager, child) {
        return DropdownButtonFormField<String>(
          value: value,
          onChanged: onChanged,
          items: [
            for (final cabin in cabinManager.cabins)
              DropdownMenuItem(
                value: cabin.id,
                child: Text(
                  '${AppLocalizations.of(context)!.cabin} ${cabin.number}',
                ),
              ),
          ],
          isExpanded: true,
        );
      },
    );
  }
}
