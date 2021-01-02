import 'package:flutter/material.dart';

class Statistics extends StatelessWidget {
  final String title;
  final IconData icon;
  final List<StatisticItem> items;

  const Statistics({
    Key key,
    this.title,
    this.icon,
    this.items,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (icon != null || title != null)
              Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  textBaseline: TextBaseline.ideographic,
                  children: [
                    if (icon != null)
                      Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: Icon(
                          icon,
                          size: 18.0,
                          color: Theme.of(context).hintColor,
                        ),
                      ),
                    if (title != null)
                      Text(
                        title,
                        style: Theme.of(context).textTheme.subtitle1,
                      ),
                  ],
                ),
              ),
            Row(
              children: [
                for (var i = 0; i < items.length; i++)
                  Container(
                    padding: (i == items.length - 1)
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
  final String value;

  const StatisticItem({
    Key key,
    this.label,
    @required this.value,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null)
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Text(
              label,
              style: theme.textTheme.subtitle2,
            ),
          ),
        Text(
          value,
          style: theme.textTheme.headline5,
        ),
      ],
    );
  }
}
