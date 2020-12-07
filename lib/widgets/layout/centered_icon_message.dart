import 'package:flutter/material.dart';

class CenteredIconMessage extends StatelessWidget {
  final IconData icon;
  final String message;

  const CenteredIconMessage({
    this.icon,
    this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 72.0,
            color: Colors.grey,
          ),
          const SizedBox(height: 24.0),
          Text(
            message,
            style: Theme.of(context)
                .textTheme
                .headline5
                .copyWith(color: Colors.grey[600]),
          ),
          const SizedBox(height: 82.0),
        ],
      ),
    );
  }
}
