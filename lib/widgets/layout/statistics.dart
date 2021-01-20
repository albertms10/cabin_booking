import 'package:flutter/material.dart';

class Statistics extends StatelessWidget {
  final String title;
  final IconData icon;
  final List<Widget> items;
  final void Function() onTap;

  const Statistics({
    Key key,
    this.title,
    this.icon,
    this.items,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: const BorderRadius.all(Radius.circular(4.0)),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (icon != null || title != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    textBaseline: TextBaseline.ideographic,
                    children: [
                      if (icon != null)
                        Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: Icon(
                            icon,
                            size: 18.0,
                            color: theme.hintColor,
                          ),
                        ),
                      if (title != null)
                        Text(
                          title,
                          style: theme.textTheme.subtitle1,
                        ),
                    ],
                  ),
                ),
              Wrap(
                spacing: 24.0,
                runSpacing: 24.0,
                children: items,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class StatisticItem extends StatelessWidget {
  final String label;
  final Widget item;

  const StatisticItem({
    Key key,
    this.label,
    @required this.item,
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
              label,
              style: Theme.of(context).textTheme.subtitle2,
            ),
          ),
        item,
      ],
    );
  }
}

class StatisticSimpleItem<T> extends StatelessWidget {
  final String label;
  final T value;

  const StatisticSimpleItem({
    Key key,
    this.label,
    @required this.value,
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
