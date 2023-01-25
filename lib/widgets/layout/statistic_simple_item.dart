import 'package:cabin_booking/widgets/layout/statistic_item.dart';
import 'package:flutter/material.dart';

class StatisticSimpleItem<T> extends StatelessWidget {
  final String? label;
  final T value;

  const StatisticSimpleItem({
    super.key,
    this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return StatisticItem(
      label: label,
      item: Text(
        '$value',
        style: Theme.of(context).textTheme.headlineSmall,
      ),
    );
  }
}
