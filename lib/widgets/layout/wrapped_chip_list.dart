import 'dart:math' show min;

import 'package:flutter/material.dart';

class WrappedChipList<T> extends StatelessWidget {
  final List<T> items;
  final Widget Function(BuildContext, T) labelBuilder;
  final int? maxChips;

  const WrappedChipList({
    required this.items,
    required this.labelBuilder,
    this.maxChips,
  });

  int get maxShown =>
      maxChips == null ? items.length : min(maxChips!, items.length);

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8.0,
      runSpacing: 6.0,
      children: [
        for (var i = 0; i < maxShown; i++)
          Chip(
            label: labelBuilder(context, items[i]),
          ),
        if (maxShown < items.length)
          Chip(
            label: Text(
              '+${items.length - maxShown}',
              style: Theme.of(context).textTheme.overline,
            ),
          ),
      ],
    );
  }
}
