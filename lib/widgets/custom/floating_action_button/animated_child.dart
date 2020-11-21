import 'package:cabin_booking/widgets/custom/floating_action_button/animated_floating_button_label.dart';
import 'package:flutter/material.dart';

class AnimatedChild extends AnimatedWidget {
  final int index;
  final Color backgroundColor;
  final Color foregroundColor;
  final double elevation;
  final IconData icon;

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

  Widget build(BuildContext context) {
    final Animation<double> animation = listenable;

    final Widget buttonChild = animation.value > 50.0
        ? Container(
            width: animation.value,
            height: animation.value,
            child: Icon(icon) ?? Container(),
          )
        : Container();

    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          AnimatedFloatingButtonLabel(
            label: label,
            animation: animation,
          ),
          Container(
            width: 62.0,
            height: animation.value,
            padding: EdgeInsets.only(bottom: 62.0 - animation.value),
            child: Container(
              height: 62.0,
              width: animation.value,
              padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
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
