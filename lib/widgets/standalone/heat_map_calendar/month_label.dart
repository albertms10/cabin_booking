import 'package:flutter/material.dart';

class MonthLabel extends StatelessWidget {
  final String text;
  final double size;
  final double space;

  const MonthLabel({
    super.key,
    required this.text,
    required this.size,
    this.space = 4,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: size,
      width: size,
      alignment: AlignmentDirectional.bottomCenter,
      padding: EdgeInsetsDirectional.only(bottom: space),
      child: Stack(
        fit: StackFit.expand,
        clipBehavior: Clip.none,
        children: [
          Positioned.directional(
            textDirection: Directionality.of(context),
            bottom: 0,
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
