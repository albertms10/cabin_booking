import 'package:flutter/material.dart';

class IconMenuItemContent extends StatelessWidget {
  final String text;
  final IconData? icon;

  const IconMenuItemContent({super.key, required this.text, this.icon});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          icon,
          size: 20.0,
          color: Theme.of(context).hintColor,
        ),
        const SizedBox(width: 14.0),
        Text(
          text,
          style: const TextStyle(fontSize: 14.0),
        ),
      ],
    );
  }
}
