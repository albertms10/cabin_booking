import 'package:cabin_booking/widgets/layout/figure_unit.dart';
import 'package:flutter/material.dart';

class DurationFigureUnit extends StatelessWidget {
  final Duration duration;

  const DurationFigureUnit(this.duration, {Key key}) : super(key: key);

  int get hours => duration.inHours;

  int get minutes => duration.inMinutes % Duration.minutesPerHour;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      mainAxisSize: MainAxisSize.min,
      children: [
        FigureUnit(
          value: hours,
          unit: 'h',
        ),
        const SizedBox(width: 8.0),
        if (minutes > 0)
          FigureUnit(
            value: minutes,
            unit: 'min',
          ),
      ],
    );
  }
}
