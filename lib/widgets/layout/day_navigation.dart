import 'package:cabin_booking/l10n/app_localizations.dart';
import 'package:flutter/material.dart';

class DayNavigation extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
          onPressed: () {},
          icon: Icon(Icons.chevron_left),
          tooltip: AppLocalizations.of(context).previousDay,
        ),
        FlatButton(
          onPressed: () {},
          child: Text(AppLocalizations.of(context).today),
        ),
        IconButton(
          onPressed: () {},
          icon: Icon(Icons.chevron_right),
          tooltip: AppLocalizations.of(context).nextDay,
        ),
      ],
    );
  }
}
