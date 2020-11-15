import 'package:cabin_booking/constants.dart';
import 'package:flutter/material.dart';

class TimeColumn extends StatelessWidget {
  final TimeOfDay start;
  final TimeOfDay end;

  TimeColumn({@required this.start, @required this.end});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (int hour = start.hour; hour <= end.hour; hour++)
          Container(
            height: 60 * bookingHeightRatio,
            padding: EdgeInsets.all(16),
            child: Text(
              TimeOfDay(hour: hour, minute: 00).format(context),
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
