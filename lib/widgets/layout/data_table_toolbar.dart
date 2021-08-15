import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class DataTableToolbar extends StatelessWidget {
  final bool shown;
  final int selectedItems;
  final VoidCallback? onPressedLeading;
  final List<Widget>? actions;

  const DataTableToolbar({
    Key? key,
    this.shown = false,
    this.selectedItems = 0,
    this.onPressedLeading,
    this.actions,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final appLocalizations = AppLocalizations.of(context)!;

    return SizedBox(
      height: 54.0,
      child: !shown
          ? null
          : AppBar(
              title: Text(appLocalizations.nSelected(selectedItems)),
              centerTitle: false,
              backgroundColor: Theme.of(context).primaryColorDark,
              leading: IconButton(
                onPressed: onPressedLeading,
                icon: const Icon(Icons.close),
                tooltip: appLocalizations.cancelSelection,
              ),
              actions: actions,
            ),
    );
  }
}
