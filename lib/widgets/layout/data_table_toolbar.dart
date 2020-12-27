import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class DataTableToolbar extends StatelessWidget {
  final bool shown;
  final int selectedItems;
  final void Function() onPressedLeading;
  final List<Widget> actions;

  const DataTableToolbar({
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
              backgroundColor: Theme.of(context).primaryColorDark,
              leading: IconButton(
                onPressed: onPressedLeading,
                icon: const Icon(Icons.close),
                tooltip: AppLocalizations.of(context).cancelSelection,
              ),
              actions: actions,
            )
          : null,
    );
  }
}
