import 'package:flutter/material.dart';

class CabinIcon extends StatelessWidget {
  final int number;

  CabinIcon({@required this.number});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blue[400],
        shape: BoxShape.circle,
      ),
      child: Text(
        '$number',
        style: Theme.of(context).accentTextTheme.headline5,
      ),
    );
  }
}
