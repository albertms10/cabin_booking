import 'package:cabin_booking/l10n/app_localizations.dart';
import 'package:flutter/material.dart';

class DeleteBookingDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(AppLocalizations.of(context).deleteBookingTitle),
      content: Text(AppLocalizations.of(context).actionUndone),
      actions: [
        FlatButton(
          onPressed: () {
            Navigator.of(context).pop(false);
          },
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(AppLocalizations.of(context).cancel.toUpperCase()),
        ),
        FlatButton(
          onPressed: () {
            Navigator.of(context).pop(true);
          },
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            AppLocalizations.of(context).delete.toUpperCase(),
            style: TextStyle(color: Colors.red),
          ),
          hoverColor: Colors.red[50],
          splashColor: Colors.red[100],
        ),
      ],
    );
  }
}
