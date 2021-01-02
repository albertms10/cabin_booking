import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart';

class ItemInfo extends StatelessWidget {
  final DateTime creationDateTime;
  final DateTime modificationDateTime;
  final int modificationCount;

  const ItemInfo({
    this.creationDateTime,
    this.modificationDateTime,
    this.modificationCount,
  });

  @override
  Widget build(BuildContext context) {
    final appLocalizations = AppLocalizations.of(context);

    return Column(
      children: [
        if (creationDateTime != null)
          Text(
            appLocalizations.createdOn(
              creationDateTime.day,
              DateFormat.yMMMd().format(creationDateTime),
            ),
            style: Theme.of(context).textTheme.caption,
          ),
        if (modificationDateTime != null)
          Text(
            appLocalizations.modifiedOn(
              modificationDateTime.day,
              DateFormat.yMMMd().format(modificationDateTime),
            ),
            style: Theme.of(context).textTheme.caption,
          ),
        if (modificationCount > 1)
          Text(
            appLocalizations.nModifications(modificationCount),
            style: Theme.of(context).textTheme.caption,
          ),
      ],
    );
  }
}
