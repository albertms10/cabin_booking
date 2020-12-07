import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class DeleteBookingDialog extends StatelessWidget {
  const DeleteBookingDialog();

  @override
  Widget build(BuildContext context) {
    final appLocalizations = AppLocalizations.of(context);

    return AlertDialog(
      title: Text(appLocalizations.deleteBookingTitle),
      content: Text(appLocalizations.actionUndone),
      actionsPadding: const EdgeInsets.all(8.0),
      actions: [
        FlatButton(
          onPressed: () {
            Navigator.of(context).pop(false);
          },
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
          child: Text(
            MaterialLocalizations.of(context).cancelButtonLabel.toUpperCase(),
          ),
        ),
        FlatButton(
          onPressed: () {
            Navigator.of(context).pop(true);
          },
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
          child: Text(
            MaterialLocalizations.of(context).deleteButtonTooltip.toUpperCase(),
            style: const TextStyle(color: Colors.red),
          ),
          hoverColor: Colors.red[50],
          splashColor: Colors.red[100],
        ),
      ],
    );
  }
}
