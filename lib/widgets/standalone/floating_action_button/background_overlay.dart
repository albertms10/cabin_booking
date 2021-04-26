import 'package:flutter/material.dart';

class BackgroundOverlay extends AnimatedWidget {
  final Color? color;
  final double opacity;

  const BackgroundOverlay({
    Key? key,
    required Animation<double> animation,
    this.color,
    this.opacity = 0.9,
  }) : super(key: key, listenable: animation);

  @override
  Widget build(BuildContext context) {
    final animation = listenable as Animation<double>;

    return Container(
      color: (color ?? Theme.of(context).scaffoldBackgroundColor)
          .withOpacity(animation.value * opacity),
    );
  }
}
