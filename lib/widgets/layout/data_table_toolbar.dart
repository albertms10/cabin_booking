import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class DataTableToolbar extends StatelessWidget {
  final bool shown;
  final int selectedItems;
  final VoidCallback? onPressedLeading;
  final List<Widget>? actions;

  const DataTableToolbar({
    super.key,
    this.shown = false,
    this.selectedItems = 0,
    this.onPressedLeading,
    this.actions,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appLocalizations = AppLocalizations.of(context)!;

    return SizedBox(
      height: 54,
      child: !shown
          ? null
          : AppBar(
              leading: IconButton(
                onPressed: onPressedLeading,
                tooltip: appLocalizations.cancelSelection,
                icon: const Icon(Icons.close),
              ),
              title: Text(appLocalizations.nSelected(selectedItems)),
              actions: actions,
              backgroundColor: theme.colorScheme.primary,
              foregroundColor: theme.colorScheme.onPrimary,
              centerTitle: false,
            ),
    );
  }
}
