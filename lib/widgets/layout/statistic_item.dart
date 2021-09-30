import 'package:flutter/material.dart';

class StatisticItem extends StatelessWidget {
  final String? label;
  final Widget item;

  const StatisticItem({
    Key? key,
    this.label,
    required this.item,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null)
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Text(
              label!,
              style: Theme.of(context).textTheme.subtitle2,
            ),
          ),
        item,
      ],
    );
  }
}
