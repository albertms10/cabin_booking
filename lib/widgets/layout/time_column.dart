import 'package:cabin_booking/constants.dart';
import 'package:flutter/material.dart';

class TimeColumn extends StatelessWidget {
  final TimeOfDay start;
  final TimeOfDay end;

  TimeColumn({
    this.start = timeTableStartTime,
    this.end = timeTableEndTime,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (int hour = start.hour; hour <= end.hour; hour++)
          Container(
            height: 60.0 * bookingHeightRatio,
            width: 180.0,
            padding: const EdgeInsets.all(16.0),
            alignment: Alignment.topCenter,
            child: Text(
              TimeOfDay(hour: hour, minute: 0).format(context),
              style: Theme.of(context)
                  .textTheme
                  .headline5
                  .copyWith(color: Colors.black45),
            ),
          ),
      ],
    );
  }
}
