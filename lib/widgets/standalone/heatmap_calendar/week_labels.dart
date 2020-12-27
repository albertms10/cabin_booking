import 'package:flutter/material.dart';

class WeekLabels extends StatelessWidget {
  final List<String> weekDaysLabels;
  final double squareSize;

  const WeekLabels({
    Key key,
    @required this.weekDaysLabels,
    @required this.squareSize,
  })  : assert(weekDaysLabels != null),
        assert(weekDaysLabels.length == 7),
        assert(squareSize != null),
        assert(squareSize > 0.0),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        SizedBox(height: squareSize),
        for (var i = 0; i < 7; i++)
          Container(
            height: squareSize,
            margin: const EdgeInsets.all(2.0),
            child: Text(
              weekDaysLabels[i],
              style: Theme.of(context).textTheme.caption,
            ),
          ),
      ],
    );
  }
}
