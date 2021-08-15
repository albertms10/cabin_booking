import 'package:cabin_booking/utils/widgets.dart';
import 'package:collection/collection.dart' show IterableExtension;
import 'package:flutter/material.dart';

class DetailedFigure<T> extends StatelessWidget {
  final T figure;
  final List<T> details;
  final Widget? detailsSeparator;
  final String? tooltipMessage;

  const DetailedFigure({
    Key? key,
    required this.figure,
    this.details = const [],
    this.detailsSeparator,
    this.tooltipMessage,
  }) : super(key: key);

  List<T> _filterIfEmpty(List<T> details) => details
      .whereNot((detail) => const [0, '', null].contains(detail))
      .toList();

  List<T> get filteredDetails => _filterIfEmpty(details);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return tooltipWrap(
      tooltipMessage: tooltipMessage,
      condition: filteredDetails.length > 1 && tooltipMessage != null,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '$figure',
            style: theme.textTheme.headline5,
          ),
          if (filteredDetails.length > 1)
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Row(
                children: [
                  for (var i = 0; i < filteredDetails.length; i++) ...[
                    Text('${filteredDetails[i]}'),
                    if (i < filteredDetails.length - 1)
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 2.0),
                        child: detailsSeparator ??
                            Text(
                              '+',
                              style: TextStyle(color: theme.hintColor),
                            ),
                      ),
                  ],
                ],
              ),
            ),
        ],
      ),
    );
  }
}
