import 'package:cabin_booking/utils/int_extension.dart';
import 'package:flutter/material.dart';

import 'utils/time.dart';

class WeekDaysLabels extends StatelessWidget {
  final double squareSize;
  final int firstWeekDay;
  final double space;

  const WeekDaysLabels({
    Key? key,
    required this.squareSize,
    this.firstWeekDay = DateTime.sunday,
    this.space = 4.0,
  })  : assert(squareSize > 0.0),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: squareSize),
        for (var i = 0; i < DateTime.daysPerWeek; i++)
          if (i.isOdd)
            Container(
              height: squareSize + space,
              padding: EdgeInsets.only(right: space),
              alignment: Alignment.centerLeft,
              child: Text(
                weekDaysLabels[i.weekDayMod(firstWeekDay - 1)],
                style: Theme.of(context).textTheme.caption,
              ),
            )
          else
            SizedBox(height: squareSize + space),
      ],
    );
  }
}
