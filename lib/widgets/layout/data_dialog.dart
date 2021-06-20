import 'package:flutter/material.dart';

class DataDialog extends StatelessWidget {
  final Widget title;
  final Widget content;

  const DataDialog({Key? key, required this.title, required this.content})
      : super(key: key);

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
            splashRadius: 24.0,
          ),
          const SizedBox(width: 8.0),
          title,
        ],
      ),
      contentPadding:
          const EdgeInsets.only(left: 24.0, right: 24.0, bottom: 24.0),
      titlePadding:
          const EdgeInsets.symmetric(horizontal: 12.0, vertical: 18.0),
      children: [content],
    );
  }
}
