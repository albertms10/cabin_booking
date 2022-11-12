import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SaveChangesSnackBarBody extends StatelessWidget {
  final bool changesSaved;

  const SaveChangesSnackBarBody({super.key, this.changesSaved = true});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appLocalizations = AppLocalizations.of(context)!;

    return Row(
      children: [
        const SizedBox(width: 72),
        Flexible(
          child: Card(
            elevation: 6,
            color: theme.snackBarTheme.backgroundColor,
            child: Padding(
              padding: const EdgeInsets.only(
                top: 12,
                right: 18,
                bottom: 12,
                left: 12,
              ),
              child: Text(
                changesSaved
                    ? appLocalizations.changesSaved
                    : appLocalizations.errorSavingChanges,
                style: theme.snackBarTheme.contentTextStyle,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
