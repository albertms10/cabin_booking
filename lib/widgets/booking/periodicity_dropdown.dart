import 'package:cabin_booking/model/recurring_booking.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class PeriodicityListTile extends StatelessWidget {
  final Periodicity value;
  final void Function(Periodicity) onChanged;

  const PeriodicityListTile({
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
