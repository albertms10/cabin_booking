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
            color: theme.snackBarTheme.backgroundColor,
            elevation: 6,
            child: Padding(
              padding: const EdgeInsetsDirectional.only(
                start: 12,
                top: 12,
                end: 18,
                bottom: 12,
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
