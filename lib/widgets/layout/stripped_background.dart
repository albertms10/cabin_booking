import 'package:cabin_booking/constants.dart';
import 'package:flutter/material.dart';

class StrippedBackground extends StatelessWidget {
  final TimeOfDay startTime;
  final TimeOfDay endTime;
  final double height;

  const StrippedBackground({
    @required this.startTime,
    @required this.endTime,
    this.height = 60.0 * bookingHeightRatio,
  });

  int get rowCount => endTime.hour - startTime.hour + 1;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      children: [
        for (var i = 0; i < rowCount; i++)
          Container(
            height: height,
            color: i.isEven ? null : const Color.fromARGB(8, 0, 0, 0),
          ),
      ],
    );
  }
}
