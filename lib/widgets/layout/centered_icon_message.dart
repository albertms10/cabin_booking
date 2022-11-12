import 'package:flutter/material.dart';

class CenteredIconMessage extends StatelessWidget {
  final IconData? icon;
  final String? message;

  const CenteredIconMessage({super.key, this.icon, this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 72.0,
            color: Colors.grey,
          ),
          if (icon != null && message != null) const SizedBox(height: 24.0),
          if (message != null)
            Text(
              message!,
              style: Theme.of(context)
                  .textTheme
                  .headline5
                  ?.copyWith(color: Colors.grey[600]),
            ),
          if (icon != null || message != null) const SizedBox(height: 82.0),
        ],
      ),
    );
  }
}
