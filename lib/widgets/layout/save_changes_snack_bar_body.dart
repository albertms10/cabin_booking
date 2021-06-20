import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SaveChangesSnackBarBody extends StatelessWidget {
  final bool changesSaved;

  const SaveChangesSnackBarBody({Key? key, this.changesSaved = true})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appLocalizations = AppLocalizations.of(context)!;

    return Row(
      children: [
        const SizedBox(width: 72.0),
        Flexible(
          child: Card(
            elevation: 6.0,
            color: theme.snackBarTheme.backgroundColor,
            child: Padding(
              padding: const EdgeInsets.only(
                top: 12.0,
                right: 18.0,
                bottom: 12.0,
                left: 12.0,
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
