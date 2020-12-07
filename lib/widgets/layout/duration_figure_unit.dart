import 'package:cabin_booking/widgets/layout/figure_unit.dart';
import 'package:flutter/material.dart';

class DurationFigureUnit extends StatelessWidget {
  final Duration duration;

  const DurationFigureUnit(this.duration);

  @override
  Widget build(BuildContext context) {
    final hours = duration.inHours;
    final minutes = duration.inMinutes % Duration.minutesPerHour;

    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
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
