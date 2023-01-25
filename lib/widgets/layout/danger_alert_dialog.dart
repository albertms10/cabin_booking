import 'package:flutter/material.dart';

class DangerAlertDialog extends StatelessWidget {
  final String title;
  final String content;
  final String? cancelText;
  final String? okText;

  const DangerAlertDialog({
    super.key,
    required this.title,
    required this.content,
    this.cancelText,
    this.okText,
  });

  @override
  Widget build(BuildContext context) {
    final materialLocalizations = MaterialLocalizations.of(context);

    const buttonPadding = EdgeInsets.symmetric(vertical: 16, horizontal: 20);

    return AlertDialog(
      title: Text(title),
      content: Text(content),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(false);
          },
          style: TextButton.styleFrom(padding: buttonPadding),
          child: Text(
            (cancelText ?? materialLocalizations.cancelButtonLabel)
                .toUpperCase(),
          ),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(true);
          },
          style: ButtonStyle(
            overlayColor: MaterialStateProperty.resolveWith<Color?>((states) {
              if (states.contains(MaterialState.hovered)) {
                return Colors.red.withOpacity(0.1);
              } else if (states.contains(MaterialState.pressed)) {
                return Colors.red.withOpacity(0.15);
              }

              return null;
            }),
            padding: MaterialStateProperty.all(buttonPadding),
          ),
          child: Text(
            (okText ?? materialLocalizations.deleteButtonTooltip).toUpperCase(),
            style: TextStyle(color: Theme.of(context).colorScheme.error),
          ),
        ),
      ],
      actionsPadding: const EdgeInsets.all(8),
    );
  }
}
