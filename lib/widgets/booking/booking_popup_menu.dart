import 'package:cabin_booking/l10n/app_localizations.dart';
import 'package:flutter/material.dart';

class BookingPopupMenu extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      onSelected: (choice) {},
      icon: const Icon(
        Icons.more_vert,
        size: 16,
        color: Colors.black54,
      ),
      itemBuilder: (BuildContext context) {
        return {
          AppLocalizations.of(context).edit,
          AppLocalizations.of(context).delete,
        }.map((String choice) {
          return PopupMenuItem(
            value: choice,
            child: Text(
              choice,
              style: TextStyle(fontSize: 14),
            ),
            height: 36,
          );
        }).toList();
      },
    );
  }
}
