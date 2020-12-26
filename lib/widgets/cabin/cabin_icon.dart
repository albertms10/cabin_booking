import 'package:flutter/material.dart';

class CabinIcon extends StatelessWidget {
  final int number;
  final double progress;

  const CabinIcon({
    Key key,
    @required this.number,
    this.progress,
  }) : super(key: key);

  double get radius => 28.0;

  bool get shouldShowProgress => progress != null;

  @override
  Widget build(BuildContext context) {
    final text = Text(
      '$number',
      style: Theme.of(context).accentTextTheme.headline5.copyWith(
            color: shouldShowProgress ? Colors.blue : null,
          ),
      textAlign: TextAlign.center,
    );

    if (!shouldShowProgress) {
      return CircleAvatar(
        radius: radius,
        backgroundColor: Colors.blue[400],
        child: text,
      );
    }

    return Stack(
      alignment: Alignment.center,
      children: [
        SizedBox(
          width: radius * 2,
          height: radius * 2,
          child: TweenAnimationBuilder<double>(
            tween: Tween<double>(begin: 0.0, end: progress),
            duration: const Duration(milliseconds: 700),
            curve: Curves.easeOutCubic,
            builder: (context, value, child) {
              return CircularProgressIndicator(
                value: value,
                backgroundColor: Colors.blue[100],
              );
            },
          ),
        ),
        text,
      ],
    );
  }
}
