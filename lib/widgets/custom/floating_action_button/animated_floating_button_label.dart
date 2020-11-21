import 'package:cabin_booking/utils/map_number.dart';
import 'package:flutter/material.dart';

class AnimatedFloatingButtonLabel extends AnimatedWidget {
  final String label;
  final Animation<double> animation;

  AnimatedFloatingButtonLabel({
    Key key,
    this.label,
    this.animation,
  }) : super(key: key, listenable: animation);

  @override
  Widget build(BuildContext context) {
    final Animation<double> animation = listenable;

    return animation.value <= 62.0 / 2
        ? Container()
        : Container(
            padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 8.0),
            margin: const EdgeInsets.only(right: 18.0),
            child: Opacity(
              opacity: mapNumber(animation.value, inMin: 31.0, inMax: 62.0),
              child: Text(
                label,
                style: Theme.of(context).textTheme.subtitle2,
              ),
            ),
          );
  }
}
