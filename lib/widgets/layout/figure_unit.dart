import 'package:flutter/material.dart';

class FigureUnit extends StatelessWidget {
  final int value;
  final String unit;

  const FigureUnit({Key key, this.value, this.unit}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          '$value',
          style: theme.textTheme.headline5,
        ),
        const SizedBox(width: 2.0),
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 2.0),
            Text(
              unit,
              style: theme.textTheme.subtitle2,
            ),
          ],
        ),
      ],
    );
  }
}
