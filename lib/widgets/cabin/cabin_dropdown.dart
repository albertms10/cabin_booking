import 'package:cabin_booking/model/cabin.dart';
import 'package:cabin_booking/model/cabin_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

class CabinDropdown extends StatelessWidget {
  final String value;
  final Function(String) onChanged;

  const CabinDropdown({
    Key key,
    this.value,
    this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<CabinManager>(
      builder: (context, cabinManager, child) {
        return DropdownButton<String>(
          value: value,
          onChanged: onChanged,
          items: [
            for (Cabin cabin in cabinManager.cabins)
              DropdownMenuItem(
                value: cabin.id,
                child: Text(
                  '${AppLocalizations.of(context).cabin} ${cabin.number}',
                ),
              ),
          ],
          isExpanded: true,
        );
      },
    );
  }
}
