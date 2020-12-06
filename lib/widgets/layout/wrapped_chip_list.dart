import 'package:flutter/material.dart';

class WrappedChipList<T> extends StatelessWidget {
  final List<T> items;
  final Function(BuildContext, T) labelBuilder;
  final int maxChips;

  const WrappedChipList({
    Key key,
    @required this.items,
    @required this.labelBuilder,
    this.maxChips,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8.0,
      runSpacing: 6.0,
      children: [
        for (final item in items)
          Chip(
            label: labelBuilder(context, item),
          )
      ],
    );
  }
}
