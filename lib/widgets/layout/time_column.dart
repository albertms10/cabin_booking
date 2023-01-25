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
                alignment: AlignmentDirectional.topCenter,
                padding: const EdgeInsets.all(16),
                width: kTimeColumnWidth,
                height: kBookingHeightRatio * 60,
                child: Text(
                  TimeOfDay(hour: hour, minute: 0).format(context),
                  style: theme.textTheme.headlineSmall
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
