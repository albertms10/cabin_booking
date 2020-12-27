import 'package:flutter/material.dart';

class DefaultContainer extends StatelessWidget {
  final double size;
  final String text;
  final Color textColor;
  final double margin;

  const DefaultContainer({
    Key key,
    @required this.size,
    @required this.text,
    @required this.textColor,
    this.margin = 2.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      height: size,
      width: size,
      child: Text(
        text,
        style: TextStyle(color: textColor),
      ),
      margin: EdgeInsets.all(margin),
    );
  }
}
