import 'package:flutter/material.dart';

class CenteredIconMessage extends StatelessWidget {
  final IconData? icon;
  final String? message;

  const CenteredIconMessage({super.key, this.icon, this.message});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 72,
            color: theme.hintColor,
          ),
          if (icon != null && message != null) const SizedBox(height: 24),
          if (message != null)
            Text(
              message!,
              style: theme.textTheme.headlineSmall
                  ?.copyWith(color: theme.hintColor),
            ),
          if (icon != null || message != null) const SizedBox(height: 82),
        ],
      ),
    );
  }
}
