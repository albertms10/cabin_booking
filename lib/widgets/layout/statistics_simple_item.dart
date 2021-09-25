import 'package:cabin_booking/widgets/layout/statistics_item.dart';
import 'package:flutter/material.dart';

class StatisticSimpleItem<T> extends StatelessWidget {
  final String? label;
  final T value;

  const StatisticSimpleItem({
    Key? key,
    this.label,
    required this.value,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StatisticItem(
      label: label,
      item: Text(
        '$value',
        style: Theme.of(context).textTheme.headline5,
      ),
    );
  }
}
