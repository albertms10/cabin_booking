import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart';

class ItemInfo extends StatelessWidget {
  final DateTime? creationDateTime;
  final DateTime? modificationDateTime;
  final int modificationCount;

  const ItemInfo({
    super.key,
    this.creationDateTime,
    this.modificationDateTime,
    this.modificationCount = 0,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appLocalizations = AppLocalizations.of(context)!;
    final dateFormat = DateFormat.yMMMd().add_Hm();

    return Column(
      children: [
        if (creationDateTime != null)
          Text(
            appLocalizations.createdOn(
              creationDateTime!.day,
              dateFormat.format(creationDateTime!.toLocal()),
            ),
            style: theme.textTheme.bodySmall,
          ),
        if (modificationDateTime != null)
          Text(
            appLocalizations.modifiedOn(
              modificationDateTime!.day,
              dateFormat.format(modificationDateTime!.toLocal()),
            ),
            style: theme.textTheme.bodySmall,
          ),
        if (modificationCount > 1)
          Text(
            appLocalizations.nModifications(modificationCount),
            style: theme.textTheme.bodySmall,
          ),
      ],
    );
  }
}
