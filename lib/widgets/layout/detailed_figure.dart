import 'package:flutter/material.dart';

class DetailedFigure<T> extends StatelessWidget {
  final T figure;
  final List<T> details;
  final Widget detailsSeparator;
  final String tooltipMessage;

  const DetailedFigure({
    this.figure,
    this.details = const [],
    this.detailsSeparator,
    this.tooltipMessage,
  });

  List<T> _filterIfEmpty(List<T> details) {
    final list = details.toList();

    list.removeWhere((detail) => [0, '', null].contains(detail));

    return list;
  }

  List<T> get filteredDetails => _filterIfEmpty(details);

  Widget _tooltipWrap({Widget child, bool condition = true}) =>
      condition ? Tooltip(message: tooltipMessage, child: child) : child;

  @override
  Widget build(BuildContext context) {
    return _tooltipWrap(
      condition: filteredDetails.length > 1 && tooltipMessage != null,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '$figure',
            style: Theme.of(context).textTheme.headline5,
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
    );
  }
}
