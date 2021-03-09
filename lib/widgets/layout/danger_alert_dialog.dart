import 'package:flutter/material.dart';

class DangerAlertDialog extends StatelessWidget {
  final String? title;
  final String? content;
  final String? cancelText;
  final String? okText;

  const DangerAlertDialog({
    this.title,
    this.content,
    this.cancelText,
    this.okText,
  });

  @override
  Widget build(BuildContext context) {
    const buttonPadding =
        EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0);

    return AlertDialog(
      title: Text(title!),
      content: Text(content!),
      actionsPadding: const EdgeInsets.all(8.0),
      actions: [
        TextButton(
          style: TextButton.styleFrom(
            padding: buttonPadding,
          ),
          onPressed: () {
            Navigator.of(context).pop(false);
          },
          child: Text(
            (cancelText ?? MaterialLocalizations.of(context).cancelButtonLabel)
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
            (okText ?? MaterialLocalizations.of(context).deleteButtonTooltip)
                .toUpperCase(),
            style: TextStyle(color: Theme.of(context).errorColor),
          ),
        ),
      ],
    );
  }
}
