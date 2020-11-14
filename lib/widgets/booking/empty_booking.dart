import 'package:cabin_booking/constants.dart';
import 'package:flutter/material.dart';

class EmptyBooking extends StatelessWidget {
  final int duration;

  EmptyBooking({this.duration = 60});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Container(
        margin: EdgeInsets.all(8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(4)),
        ),
        child: Tooltip(
          message: '$duration min',
          child: InkWell(
            borderRadius: BorderRadius.all(Radius.circular(4)),
            onTap: () {},
            child: Icon(
              Icons.add,
              size: 18,
              color: Colors.black38,
            ),
          ),
        ),
      ),
      width: double.infinity,
      height: duration * bookingHeightRatio,
    );
  }
}
