import 'package:flutter/material.dart';

class DataDialog extends StatelessWidget {
  final Widget title;
  final Widget content;

  const DataDialog({super.key, required this.title, required this.content});

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      title: Row(
        children: [
          IconButton(
            splashRadius: 24,
            onPressed: () {
              Navigator.of(context).pop();
            },
            tooltip: MaterialLocalizations.of(context).backButtonTooltip,
            icon: const Icon(Icons.arrow_back),
          ),
          const SizedBox(width: 8),
          title,
        ],
      ),
      titlePadding: const EdgeInsets.symmetric(vertical: 18, horizontal: 12),
      contentPadding:
          const EdgeInsetsDirectional.only(start: 24, end: 24, bottom: 24),
      children: [content],
    );
  }
}
