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

    const buttonPadding = EdgeInsets.symmetric(horizontal: 20, vertical: 16);

    return AlertDialog(
      title: Text(title),
      content: Text(content),
      actionsPadding: const EdgeInsets.all(8),
      actions: [
        TextButton(
          style: TextButton.styleFrom(
            padding: buttonPadding,
          ),
          onPressed: () {
            Navigator.of(context).pop(false);
          },
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
            padding: MaterialStateProperty.all(buttonPadding),
            overlayColor: MaterialStateProperty.resolveWith<Color?>((states) {
              if (states.contains(MaterialState.hovered)) {
                return Colors.red.withOpacity(0.1);
              } else if (states.contains(MaterialState.pressed)) {
                return Colors.red.withOpacity(0.15);
              }

              return null;
            }),
          ),
          child: Text(
            (okText ?? materialLocalizations.deleteButtonTooltip).toUpperCase(),
            style: TextStyle(color: Theme.of(context).errorColor),
          ),
        ),
      ],
    );
  }
}
