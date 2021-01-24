import 'package:flutter/material.dart';

class DangerAlertDialog extends StatelessWidget {
  final String title;
  final String content;
  final String cancelText;
  final String okText;

  const DangerAlertDialog({
    this.title,
    this.content,
    this.cancelText,
    this.okText,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title),
      content: Text(content),
      actionsPadding: const EdgeInsets.all(8.0),
      actions: [
        FlatButton(
          onPressed: () {
            Navigator.of(context).pop(false);
          },
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
          child: Text(
            (cancelText ?? MaterialLocalizations.of(context).cancelButtonLabel)
                .toUpperCase(),
          ),
        ),
        FlatButton(
          onPressed: () {
            Navigator.of(context).pop(true);
          },
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
          hoverColor: Colors.red.withOpacity(0.1),
          splashColor: Colors.red.withOpacity(0.15),
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
