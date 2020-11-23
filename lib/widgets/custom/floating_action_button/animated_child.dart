import 'package:cabin_booking/widgets/custom/floating_action_button/animated_floating_button_label.dart';
import 'package:flutter/material.dart';

class AnimatedChild extends AnimatedWidget {
  final int index;
  final Color backgroundColor;
  final Color foregroundColor;
  final double elevation;
  final IconData icon;
  final Tween<double> tween;

  final String label;
  final TextStyle labelStyle;
  final Color labelBackgroundColor;
  final Widget labelWidget;

  final bool visible;
  final VoidCallback onTap;
  final VoidCallback toggleChildren;
  final ShapeBorder shape;
  final String heroTag;

  AnimatedChild({
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
    this.labelWidget,
    this.visible = false,
    this.onTap,
    this.toggleChildren,
    this.shape,
    this.heroTag,
  }) : super(key: key, listenable: animation);

  void _performAction() {
    if (onTap != null) onTap();

    toggleChildren();
  }

  @override
  Widget build(BuildContext context) {
    final Animation<double> animation = listenable;

    final Widget buttonChild = animation.value > 50.0
        ? SizedBox(
            width: animation.value,
            height: animation.value,
            child: Icon(
              icon,
              size: animation.value / 3,
            ),
          )
        : const SizedBox();

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
                onPressed: _performAction,
                backgroundColor: backgroundColor,
                foregroundColor: foregroundColor,
                elevation: elevation,
                child: buttonChild,
              ),
            ),
          )
        ],
      ),
    );
  }
}
