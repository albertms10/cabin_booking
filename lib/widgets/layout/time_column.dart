import 'package:cabin_booking/constants.dart';
import 'package:cabin_booking/widgets/layout/current_time_indicator.dart';
import 'package:cabin_booking/widgets/layout/striped_background.dart';
import 'package:flutter/material.dart';

class TimeColumn extends StatelessWidget {
  final TimeOfDay start;
  final TimeOfDay end;

  const TimeColumn({
    super.key,
    this.start = kTimeTableStartTime,
    this.end = kTimeTableEndTime,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Stack(
      children: [
        const StripedBackground(
          startTime: kTimeTableStartTime,
          endTime: kTimeTableEndTime,
        ),
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            for (var hour = start.hour; hour <= end.hour; hour++)
              Container(
                width: kTimeColumnWidth,
                height: kBookingHeightRatio * 60.0,
                padding: const EdgeInsets.all(16.0),
                alignment: Alignment.topCenter,
                child: Text(
                  TimeOfDay(hour: hour, minute: 0).format(context),
                  style: theme.textTheme.headline5
                      ?.copyWith(color: theme.hintColor),
                ),
              ),
          ],
        ),
        const CurrentTimeIndicator(),
      ],
    );
  }
}
