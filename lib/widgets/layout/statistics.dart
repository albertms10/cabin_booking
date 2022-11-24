import 'package:flutter/material.dart';

class Statistics extends StatelessWidget {
  final String? title;
  final IconData? icon;
  final List<Widget> items;
  final VoidCallback? onTap;

  const Statistics({
    super.key,
    this.title,
    this.icon,
    this.items = const [],
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: const BorderRadius.all(Radius.circular(4)),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (icon != null || title != null)
                _StatisticsHeading(title: title, icon: icon),
              Wrap(
                spacing: 24,
                runSpacing: 24,
                children: items,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatisticsHeading extends StatelessWidget {
  final String? title;
  final IconData? icon;

  const _StatisticsHeading({super.key, this.title, this.icon});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsetsDirectional.only(bottom: 16),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        textBaseline: TextBaseline.ideographic,
        children: [
          if (icon != null)
            Padding(
              padding: const EdgeInsetsDirectional.only(end: 8),
              child: Icon(
                icon,
                size: 18,
                color: theme.hintColor,
              ),
            ),
          if (title != null)
            Text(
              title!,
              style: theme.textTheme.subtitle1,
            ),
        ],
      ),
    );
  }
}
