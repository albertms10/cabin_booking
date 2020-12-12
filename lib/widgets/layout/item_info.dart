import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart';

class ItemInfo extends StatelessWidget {
  final DateTime creationDate;
  final DateTime modificationDate;
  final int modificationCount;

  const ItemInfo({
    this.creationDate,
    this.modificationDate,
    this.modificationCount,
  });

  @override
  Widget build(BuildContext context) {
    final appLocalizations = AppLocalizations.of(context);

    return Column(
      children: [
        const SizedBox(height: 16.0),
        Text(
          appLocalizations.createdOn(
            creationDate.day,
            DateFormat.yMMMd().format(creationDate),
          ),
          style: Theme.of(context).textTheme.caption,
        ),
        if (modificationDate != null)
          Text(
            appLocalizations.modifiedOn(
              modificationDate.day,
              DateFormat.yMMMd().format(modificationDate),
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
