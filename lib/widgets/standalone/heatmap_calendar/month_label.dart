import 'package:flutter/material.dart';

class MonthLabel extends StatelessWidget {
  final String text;
  final double size;

  const MonthLabel({
    Key key,
    @required this.text,
    @required this.size,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.bottomCenter,
      height: size,
      width: size,
      child: Stack(
        fit: StackFit.expand,
        clipBehavior: Clip.none,
        children: <Widget>[
          Positioned(
            bottom: 0.0,
            child: Text(
              text,
              style: Theme.of(context).textTheme.caption,
            ),
          ),
        ],
      ),
    );
  }
}
