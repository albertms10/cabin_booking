import 'package:cabin_booking/model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class PeriodicityListTile extends StatelessWidget {
  final Periodicity value;
  final void Function(Periodicity?)? onChanged;

  const PeriodicityListTile({
    super.key,
    required this.value,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final appLocalizations = AppLocalizations.of(context)!;

    final periodicityLabels = [
      appLocalizations.daily,
      appLocalizations.weekly,
      appLocalizations.monthly,
      appLocalizations.annually,
    ];

    return ListTile(
      title: Text(appLocalizations.repeats),
      minVerticalPadding: 24.0,
      trailing: SizedBox(
        width: 182.0,
        child: DropdownButtonFormField(
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
        ),
      ),
    );
  }
}
