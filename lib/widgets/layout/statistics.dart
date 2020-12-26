import 'package:flutter/material.dart';

class Statistics extends StatelessWidget {
  final String title;
  final List<StatisticItem> items;

  const Statistics({Key key, this.title, this.items}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (title != null)
              Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: Text(
                  title,
                  style: Theme.of(context).textTheme.subtitle1,
                ),
              ),
            Row(
              children: [
                for (var i = 0; i < items.length; i++)
                  Container(
                    padding: i == items.length - 1
                        ? null
                        : const EdgeInsets.only(right: 32.0),
                    child: items[i],
                  )
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class StatisticItem extends StatelessWidget {
  final String label;
  final num value;

  const StatisticItem({Key key, this.label, this.value}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: theme.textTheme.subtitle2,
        ),
        const SizedBox(height: 8.0),
        Text(
          '${value}',
          style: theme.textTheme.headline5,
        ),
      ],
    );
  }
}
