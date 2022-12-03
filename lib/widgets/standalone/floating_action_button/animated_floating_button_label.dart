import 'package:cabin_booking/utils/num_extension.dart';
import 'package:flutter/material.dart';

class AnimatedFloatingButtonLabel extends AnimatedWidget {
  final Widget? label;
  final Tween<double> tween;
  final Animation<double> animation;

  const AnimatedFloatingButtonLabel({
    super.key,
    this.label,
    required this.tween,
    required this.animation,
  }) : super(listenable: animation);

  @override
  Widget build(BuildContext context) {
    final animation = listenable as Animation<double>;

    if (animation.value <= (tween.end ?? 0) * 0.5) return const SizedBox();

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 8),
      margin: const EdgeInsetsDirectional.only(end: 18),
      child: Opacity(
        opacity: animation.value
            .map(inMin: (tween.end ?? 0) * 0.5, inMax: tween.end ?? 0)
            .toDouble(),
        child: label,
      ),
    );
  }
}
