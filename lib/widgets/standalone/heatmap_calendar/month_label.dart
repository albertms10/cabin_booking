import 'package:flutter/material.dart';

class MonthLabel extends StatelessWidget {
  final String text;
  final double size;
  final double space;

  const MonthLabel({
    Key key,
    @required this.text,
    @required this.size,
    this.space = 4.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: size,
      width: size,
      alignment: Alignment.bottomCenter,
      padding: EdgeInsets.only(bottom: space),
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
