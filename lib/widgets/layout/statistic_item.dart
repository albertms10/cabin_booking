import 'package:flutter/material.dart';

class StatisticItem extends StatelessWidget {
  final String? label;
  final Widget item;

  const StatisticItem({
    super.key,
    this.label,
    required this.item,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null)
          Padding(
            padding: const EdgeInsetsDirectional.only(bottom: 8),
            child: Text(
              label!,
              style: Theme.of(context).textTheme.titleSmall,
            ),
          ),
        item,
      ],
    );
  }
}
