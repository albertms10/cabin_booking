import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart';

class ItemInfo extends StatelessWidget {
  final DateTime? creationDateTime;
  final DateTime? modificationDateTime;
  final int modificationCount;

  const ItemInfo({
    this.creationDateTime,
    this.modificationDateTime,
    this.modificationCount = 0,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appLocalizations = AppLocalizations.of(context)!;

    return Column(
      children: [
        if (creationDateTime != null)
          Text(
            appLocalizations.createdOn(
              creationDateTime!.day,
              DateFormat.yMMMd().format(creationDateTime!),
            ),
            style: theme.textTheme.caption,
          ),
        if (modificationDateTime != null)
          Text(
            appLocalizations.modifiedOn(
              modificationDateTime!.day,
              DateFormat.yMMMd().format(modificationDateTime!),
            ),
            style: theme.textTheme.caption,
          ),
        if (modificationCount > 1)
          Text(
            appLocalizations.nModifications(modificationCount),
            style: theme.textTheme.caption,
          ),
      ],
    );
  }
}
