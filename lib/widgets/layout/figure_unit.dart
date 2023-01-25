import 'package:flutter/material.dart';

class FigureUnit extends StatelessWidget {
  final int value;
  final String unit;

  const FigureUnit({super.key, required this.value, required this.unit});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('$value', style: theme.textTheme.headlineSmall),
        const SizedBox(width: 2),
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 2),
            Text(unit, style: theme.textTheme.titleSmall),
          ],
        ),
      ],
    );
  }
}
