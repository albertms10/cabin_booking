import 'package:flutter/material.dart';

class CabinIcon extends StatelessWidget {
  final int number;
  final double progress;

  const CabinIcon({@required this.number, this.progress});

  @override
  Widget build(BuildContext context) {
    final size = 52.0;
    final showProgress = progress != null;

    final text = Text(
      '$number',
      style: Theme.of(context).accentTextTheme.headline5.copyWith(
            color: showProgress ? Colors.blue : null,
          ),
      textAlign: TextAlign.center,
    );

    if (showProgress) {
      return Stack(
        alignment: Alignment.center,
        children: [
          SizedBox(
            width: size,
            height: size,
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

    return Container(
      width: size,
      height: size,
      padding: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        color: Colors.blue[400],
        shape: BoxShape.circle,
      ),
      child: text,
    );
  }
}
