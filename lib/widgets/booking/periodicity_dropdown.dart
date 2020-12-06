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
    final appLocalizations = AppLocalizations.of(context);

    final periodicityLabels = [
      appLocalizations.daily,
      appLocalizations.weekly,
      appLocalizations.monthly,
      appLocalizations.annually,
    ];

    return DropdownButtonFormField(
      value: value,
      onChanged: onChanged,
      items: [
        for (final value in Periodicity.values)
          DropdownMenuItem(
            value: value,
            child: Text(
              periodicityLabels[value.index],
            ),
          ),
      ],
    );
  }
}
