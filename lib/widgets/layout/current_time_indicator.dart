import 'package:cabin_booking/constants.dart';
import 'package:cabin_booking/model/day_handler.dart';
import 'package:cabin_booking/utils/time_of_day.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:timer_builder/timer_builder.dart';

class CurrentTimeIndicator extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return TimerBuilder.periodic(
      Duration(seconds: 5),
      builder: (context) {
        final dayHandler = Provider.of<DayHandler>(context);

        final viewStartDateTime = tryParseDateTimeWithFormattedTimeOfDay(
          dateTime: dayHandler.dateTime,
          formattedTimeOfDay: timeTableStartTime.format(context),
        );

        final viewEndDateTime = tryParseDateTimeWithFormattedTimeOfDay(
          dateTime: dayHandler.dateTime,
          formattedTimeOfDay: timeTableEndTime.format(context),
        );

        final int differenceFromViewStartTime =
            DateTime.now().difference(viewStartDateTime).inMinutes;

        final int differenceFromViewEndTime =
            DateTime.now().difference(viewEndDateTime).inMinutes;

        return differenceFromViewStartTime > 0 && differenceFromViewEndTime < 0
            ? Column(
                children: [
                  SizedBox(
                    height: differenceFromViewStartTime * bookingHeightRatio,
                    child: Container(
                      alignment: Alignment.bottomLeft,
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        TimeOfDay.fromDateTime(DateTime.now()).format(context),
                        style: TextStyle(
                          color: Colors.red[400],
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    height: 2.0,
                    decoration: BoxDecoration(
                      color: Colors.red[400],
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 3.0,
                          offset: Offset(3.0, 4.0),
                        ),
                      ],
                    ),
                  ),
                ],
              )
            : const SizedBox();
      },
    );
  }
}
