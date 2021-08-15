import 'package:flutter/material.dart';

Widget tooltipWrap({
  required Widget child,
  String? tooltipMessage,
  bool condition = true,
}) {
  if (condition) {
    if (tooltipMessage == null) {
      throw ArgumentError('Tooltip message not provided');
    }
    return Tooltip(message: tooltipMessage, child: child);
  }
  return child;
}
