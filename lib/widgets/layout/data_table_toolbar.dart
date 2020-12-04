import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class DataTableToolbar extends StatelessWidget {
  final bool shown;
  final int selectedItems;
  final Function onPressedLeading;
  final List<Widget> actions;

  DataTableToolbar({
    this.shown = false,
    this.selectedItems = 0,
    this.onPressedLeading,
    this.actions,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 54.0,
      child: shown
          ? AppBar(
              title: Text(
                AppLocalizations.of(context).nSelected(selectedItems),
              ),
              centerTitle: false,
              backgroundColor: Colors.blue[700],
              leading: IconButton(
                onPressed: onPressedLeading,
                icon: const Icon(Icons.close),
              ),
              actions: actions,
            )
          : null,
    );
  }
}
