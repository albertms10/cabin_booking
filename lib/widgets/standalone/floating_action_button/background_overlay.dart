import 'package:flutter/material.dart';

class BackgroundOverlay extends AnimatedWidget {
  final Color color;
  final double opacity;

  const BackgroundOverlay({
    Key key,
    Animation<double> animation,
    this.color,
    this.opacity = 0.9,
  }) : super(key: key, listenable: animation);

  @override
  Widget build(BuildContext context) {
    final Animation<double> animation = listenable;

    return Container(
      color: (color ?? Theme.of(context).scaffoldBackgroundColor)
          .withOpacity(animation.value * opacity),
    );
  }
}
