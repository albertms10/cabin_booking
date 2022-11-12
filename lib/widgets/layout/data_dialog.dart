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
            icon: const Icon(Icons.arrow_back),
            tooltip: MaterialLocalizations.of(context).backButtonTooltip,
            onPressed: () {
              Navigator.of(context).pop();
            },
            splashRadius: 24,
          ),
          const SizedBox(width: 8),
          title,
        ],
      ),
      contentPadding: const EdgeInsets.only(left: 24, right: 24, bottom: 24),
      titlePadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 18),
      children: [content],
    );
  }
}
