import 'package:cabin_booking/constants.dart';
import 'package:flutter/material.dart';

class StrippedBackground extends StatelessWidget {
  final int count;
  final double height;

  StrippedBackground({
    this.count = 0,
    this.height = 60.0 * bookingHeightRatio,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      children: [
        for (int i = 0; i < count; i++)
          Container(
            height: height,
            color: i % 2 == 0 ? null : const Color.fromARGB(8, 0, 0, 0),
          ),
      ],
    );
  }
}
