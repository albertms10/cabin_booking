import 'package:cabin_booking/utils/iterable_extension.dart';
import 'package:cabin_booking/widgets/layout/conditional_widget_wrap.dart';
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

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final filteredDetails = details.whereTruthy();

    return ConditionalWidgetWrap(
      condition: filteredDetails.length > 1 && tooltipMessage != null,
      conditionalBuilder: (child) {
        return Tooltip(
          message: tooltipMessage,
          child: child,
        );
      },
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
                    Text('${filteredDetails.elementAt(i)}'),
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
