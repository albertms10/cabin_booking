import 'package:cabin_booking/constants.dart';
import 'package:flutter/material.dart';

class TimeColumn extends StatelessWidget {
  final TimeOfDay start;
  final TimeOfDay end;

  const TimeColumn({
    this.start = timeTableStartTime,
    this.end = timeTableEndTime,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (var hour = start.hour; hour <= end.hour; hour++)
          Container(
            width: 180.0,
            height: 60.0 * bookingHeightRatio,
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
