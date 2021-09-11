import 'package:flutter/material.dart';

Widget tooltipWrap({
  String? tooltipMessage,
  bool condition = true,
  required Widget child,
}) {
  if (!condition) return child;
  if (tooltipMessage == null) {
    throw ArgumentError('Tooltip message not provided');
  }
  return Tooltip(message: tooltipMessage, child: child);
}
