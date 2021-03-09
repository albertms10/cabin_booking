import 'package:flutter/material.dart';

Widget? tooltipWrap({
  String? tooltipMessage,
  bool condition = true,
  Widget? child,
}) =>
    condition ? Tooltip(message: tooltipMessage!, child: child) : child;
