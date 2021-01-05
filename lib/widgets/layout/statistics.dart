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
  final List<Widget> details;
  final Widget detailsSeparator;
  final String tooltipMessage;

  const StatisticItem({
    Key key,
    this.label,
    @required this.item,
    this.details = const [],
    this.detailsSeparator,
    this.tooltipMessage,
  }) : super(key: key);

  Widget _tooltipWrap({Widget child}) => tooltipMessage != null
      ? Tooltip(message: tooltipMessage, child: child)
      : child;

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
        _tooltipWrap(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              item,
              if (details.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Row(
                    children: [
                      for (var i = 0; i < details.length; i++) ...[
                        details[i],
                        if (i < details.length - 1)
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 2.0),
                            child: detailsSeparator ??
                                Text(
                                  '+',
                                  style: TextStyle(
                                    color: Theme.of(context).hintColor,
                                  ),
                                ),
                          ),
                      ],
                    ],
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}

class StatisticSimpleItem<T> extends StatelessWidget {
  final String label;
  final T value;
  final List<T> details;
  final Widget detailsSeparator;
  final String tooltipMessage;

  const StatisticSimpleItem({
    Key key,
    this.label,
    @required this.value,
    this.details = const [],
    this.detailsSeparator,
    this.tooltipMessage,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StatisticItem(
      label: label,
      item: Text(
        '$value',
        style: Theme.of(context).textTheme.headline5,
      ),
      details: [
        for (final detail in details) Text('$detail'),
      ],
      detailsSeparator: detailsSeparator,
      tooltipMessage: tooltipMessage,
    );
  }
}
