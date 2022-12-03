import 'dart:io';

import 'package:cabin_booking/services/show_jump_bar_intent.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ActionableFocusedShortcuts extends StatelessWidget {
  final Widget child;

  const ActionableFocusedShortcuts({super.key, required this.child});

  LogicalKeySet get _jumpBarLogicalKeySet => Platform.isMacOS
      ? LogicalKeySet(LogicalKeyboardKey.meta, LogicalKeyboardKey.keyK)
      : LogicalKeySet(LogicalKeyboardKey.control, LogicalKeyboardKey.keyK);

  @override
  Widget build(BuildContext context) {
    return Shortcuts(
      shortcuts: {
        _jumpBarLogicalKeySet: const ShowJumpBarIntent(),
      },
      child: Actions(
        actions: {
          ShowJumpBarIntent: ShowJumpBarAction(context),
        },
        child: Focus(
          autofocus: true,
          child: child,
        ),
      ),
    );
  }
}
