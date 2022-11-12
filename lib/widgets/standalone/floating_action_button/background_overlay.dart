import 'package:flutter/material.dart';

class BackgroundOverlay extends AnimatedWidget {
  final Color? color;
  final double opacity;

  const BackgroundOverlay({
    super.key,
    required Animation<double> animation,
    this.color,
    this.opacity = 0.9,
  }) : super(listenable: animation);

  @override
  Widget build(BuildContext context) {
    final animation = listenable as Animation<double>;

    return ColoredBox(
      color: (color ?? Theme.of(context).scaffoldBackgroundColor)
          .withOpacity(animation.value * opacity),
    );
  }
}
