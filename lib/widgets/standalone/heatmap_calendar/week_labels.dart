import 'package:flutter/material.dart';

import 'default_container.dart';

class WeekLabels extends StatelessWidget {
  final List<String> weekDaysLabels;
  final double squareSize;
  final Color labelTextColor;

  const WeekLabels({
    Key key,
    @required this.weekDaysLabels,
    @required this.squareSize,
    @required this.labelTextColor,
  })  : assert(weekDaysLabels != null),
        assert(weekDaysLabels.length == 7),
        assert(squareSize != null),
        assert(squareSize > 0.0),
        assert(labelTextColor != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        DefaultContainer(
          text: '',
          size: squareSize,
          textColor: labelTextColor,
          margin: 0,
        ),
        for (var i = 0; i < 7; i++)
          DefaultContainer(
            text: weekDaysLabels[i],
            size: squareSize,
            textColor: labelTextColor,
          ),
      ],
    );
  }
}
