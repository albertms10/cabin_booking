import 'package:flutter/material.dart';

import 'animated_floating_button_label.dart';

class AnimatedChild extends AnimatedWidget {
  final int index;
  final Color backgroundColor;
  final Color foregroundColor;
  final double elevation;
  final IconData icon;
  final Tween<double> tween;

  final Widget label;
  final TextStyle labelStyle;
  final Color labelBackgroundColor;

  final bool visible;
  final VoidCallback onTap;
  final VoidCallback toggleChildren;
  final ShapeBorder shape;
  final String heroTag;

  const AnimatedChild({
    Key key,
    Animation<double> animation,
    this.tween,
    this.index,
    this.backgroundColor,
    this.foregroundColor,
    this.elevation = 6.0,
    this.icon,
    this.label,
    this.labelStyle,
    this.labelBackgroundColor,
    this.visible = false,
    this.onTap,
    this.toggleChildren,
    this.shape,
    this.heroTag,
  }) : super(key: key, listenable: animation);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final Animation<double> animation = listenable;

    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          AnimatedFloatingButtonLabel(
            tween: tween,
            label: label,
            animation: animation,
          ),
          Container(
            width: tween.end,
            height: animation.value,
            padding: EdgeInsets.only(bottom: tween.end - animation.value),
            child: Container(
              width: animation.value,
              height: tween.end,
              padding: const EdgeInsets.symmetric(vertical: 10.0),
              child: FloatingActionButton(
                heroTag: heroTag,
                onPressed: () {
                  if (onTap != null) onTap();

                  toggleChildren();
                },
                backgroundColor: backgroundColor ?? theme.dialogBackgroundColor,
                foregroundColor: foregroundColor ?? theme.accentColor,
                elevation: elevation,
                child: animation.value > 50.0
                    ? SizedBox(
                        width: animation.value,
                        height: animation.value,
                        child: Icon(
                          icon,
                          size: animation.value / 3,
                        ),
                      )
                    : const SizedBox(),
              ),
            ),
          )
        ],
      ),
    );
  }
}
