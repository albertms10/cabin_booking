import 'package:cabin_booking/constants.dart';
import 'package:flutter/material.dart';

class TimeColumn extends StatelessWidget {
  final TimeOfDay start;
  final TimeOfDay end;

  const TimeColumn({
    this.start = kTimeTableStartTime,
    this.end = kTimeTableEndTime,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (var hour = start.hour; hour <= end.hour; hour++)
          Container(
            width: kTimeColumnWidth,
            height: 60.0 * kBookingHeightRatio,
            padding: const EdgeInsets.all(16.0),
            alignment: Alignment.topCenter,
            child: Text(
              TimeOfDay(hour: hour, minute: 0).format(context),
              style: theme.textTheme.headline5.copyWith(color: theme.hintColor),
            ),
          ),
      ],
    );
  }
}
