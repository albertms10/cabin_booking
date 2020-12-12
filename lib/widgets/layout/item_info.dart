import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ItemInfo extends StatelessWidget {
  final DateTime creationDate;
  final DateTime modificationDate;
  final int modificationCount;

  const ItemInfo({
    this.creationDate,
    this.modificationDate,
    this.modificationCount,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 16.0),
        Text(
          'Created on ${DateFormat.yMMMd().format(creationDate)}',
          style: Theme.of(context).textTheme.caption,
        ),
        if (modificationDate != null)
          Text(
            'Modified on ${DateFormat.yMMMd().format(modificationDate)} (${modificationCount})',
            style: Theme.of(context).textTheme.caption,
          ),
      ],
    );
  }
}
