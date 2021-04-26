import 'package:cabin_booking/utils/map_number.dart';
import 'package:flutter/material.dart';

class AnimatedFloatingButtonLabel extends AnimatedWidget {
  final Widget? label;
  final Tween<double> tween;
  final Animation<double> animation;

  const AnimatedFloatingButtonLabel({
    Key? key,
    this.label,
    required this.tween,
    required this.animation,
  }) : super(key: key, listenable: animation);

  @override
  Widget build(BuildContext context) {
    final animation = listenable as Animation<double>;

    if (animation.value <= (tween.end ?? 0.0) / 2.0) return const SizedBox();

    return Container(
      margin: const EdgeInsets.only(right: 18.0),
      padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 8.0),
      child: Opacity(
        opacity: mapNumber(
          animation.value,
          inMin: (tween.end ?? 0.0) / 2.0,
          inMax: tween.end ?? 0.0,
        ),
        child: label,
      ),
    );
  }
}
