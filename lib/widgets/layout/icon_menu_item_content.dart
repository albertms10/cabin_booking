import 'package:flutter/material.dart';

class IconMenuItemContent extends StatelessWidget {
  final String text;
  final IconData icon;

  IconMenuItemContent({@required this.text, this.icon});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          icon,
          size: 20.0,
          color: Colors.black54,
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
