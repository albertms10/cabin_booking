import 'package:cabin_booking/constants.dart';
import 'package:flutter/material.dart';

class StripedBackground extends StatelessWidget {
  final TimeOfDay startTime;
  final TimeOfDay endTime;
  final double height;

  const StripedBackground({
    super.key,
    required this.startTime,
    required this.endTime,
    this.height = kBookingHeightRatio * 60,
  });

  int get rowCount => (endTime.hour - startTime.hour).abs() + 1;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (var i = 0; i < rowCount; i++)
          Container(
            color: i.isEven ? null : const Color.fromARGB(8, 0, 0, 0),
            height: height,
          ),
      ],
    );
  }
}
