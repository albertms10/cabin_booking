import 'package:flutter/material.dart';

class Heading extends StatelessWidget {
  final String heading;
  final bool divider;

  const Heading(
    this.heading, {
    Key? key,
    this.divider = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          heading,
          style: theme.textTheme.headline5!.copyWith(
            color: theme.colorScheme.onSurface.withOpacity(0.8),
          ),
        ),
        if (divider) const Divider(),
      ],
    );
  }
}
