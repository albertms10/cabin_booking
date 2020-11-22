import 'package:flutter/material.dart';

class CabinIcon extends StatelessWidget {
  final int number;

  CabinIcon({@required this.number});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 52.0,
      width: 52.0,
      padding: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        color: Colors.blue[400],
        shape: BoxShape.circle,
      ),
      child: Text(
        '$number',
        style: Theme.of(context).accentTextTheme.headline5,
        textAlign: TextAlign.center,
      ),
    );
  }
}
