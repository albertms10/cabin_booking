import 'package:cabin_booking/constants.dart';
import 'package:cabin_booking/model/day_handler.dart';
import 'package:cabin_booking/utils/datetime.dart';
import 'package:cabin_booking/widgets/layout/horizontal_indicator.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:timer_builder/timer_builder.dart';

class CurrentTimeIndicator extends StatelessWidget {
  const CurrentTimeIndicator();

  @override
  Widget build(BuildContext context) {
    return TimerBuilder.periodic(
      const Duration(seconds: 5),
      builder: (context) {
        final dayHandler = Provider.of<DayHandler>(context);

        final viewStartDateTime = dateTimeWithTimeOfDay(
          dateTime: dayHandler.dateTime,
          timeOfDay: kTimeTableStartTime,
        );

        final viewEndDateTime = dateTimeWithTimeOfDay(
          dateTime: dayHandler.dateTime,
          timeOfDay: kTimeTableEndTime,
        );

        final durationFromStart = DateTime.now().difference(viewStartDateTime);

        final durationFromEnd = DateTime.now().difference(viewEndDateTime);

        if (durationFromStart <= const Duration() ||
            durationFromEnd >= const Duration(minutes: 15)) {
          return const SizedBox();
        }

        return HorizontalIndicator(
          verticalOffset: durationFromStart.inMicroseconds /
              Duration.microsecondsPerMinute *
              kBookingHeightRatio,
          label: Text(
            TimeOfDay.fromDateTime(DateTime.now()).format(context),
            style: TextStyle(
              color: Colors.red[400],
              fontWeight: FontWeight.bold,
            ),
          ),
          indicatorColor: Colors.red[400],
        );
      },
    );
  }
}
