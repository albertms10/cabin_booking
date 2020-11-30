import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

enum Periodicity {
  daily,
  weekly,
  monthly,
  annually,
}

class PeriodicityDropdown extends StatelessWidget {
  final Periodicity value;
  final Function(Periodicity) onChanged;

  const PeriodicityDropdown({
    Key key,
    this.value,
    this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final periodicityTranslations = [
      AppLocalizations.of(context).daily,
      AppLocalizations.of(context).weekly,
      AppLocalizations.of(context).monthly,
      AppLocalizations.of(context).annually,
    ];

    return DropdownButton(
      value: value,
      onChanged: onChanged,
      items: [
        for (Periodicity value in Periodicity.values)
          DropdownMenuItem(
            value: value,
            child: Text(
              periodicityTranslations[value.index],
            ),
          ),
      ],
    );
  }
}
