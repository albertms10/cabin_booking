import 'package:cabin_booking/widgets/standalone/heatmap_calendar/time_utils.dart';
import 'package:flutter/material.dart';

class WeekLabels extends StatelessWidget {
  final double squareSize;
  final double space;

  const WeekLabels({
    Key key,
    @required this.squareSize,
    this.space = 4.0,
  })  : assert(squareSize != null),
        assert(squareSize > 0.0),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        SizedBox(height: squareSize),
        for (var i = 0; i < 7; i++)
          if (i.isOdd)
            Container(
              height: squareSize + space,
              padding: EdgeInsets.only(right: space),
              alignment: Alignment.centerLeft,
              child: Text(
                TimeUtils.weekLabels[i],
                style: Theme.of(context).textTheme.caption,
              ),
            )
          else
            SizedBox(
              height: squareSize + space,
            )
      ],
    );
  }
}
