import 'package:cabin_booking/widgets/custom/floating_action_button/animated_floating_button_label.dart';
import 'package:flutter/material.dart';

class AnimatedFloatingButton extends StatelessWidget {
  final bool visible;
  final Tween<double> tween;
  final Animation<double> animation;
  final VoidCallback callback;
  final VoidCallback onLongPress;
  final Widget child;
  final Color backgroundColor;
  final Color foregroundColor;
  final String tooltip;
  final Widget label;
  final String heroTag;
  final double elevation;
  final bool isOpen;
  final ShapeBorder shape;
  final Curve curve;
  final int animationSpeed;

  const AnimatedFloatingButton({
    this.visible = true,
    this.tween,
    this.animation,
    this.callback,
    this.child,
    this.backgroundColor,
    this.foregroundColor,
    this.tooltip,
    this.label,
    this.heroTag,
    this.elevation = 6.0,
    this.isOpen = false,
    this.shape = const CircleBorder(),
    this.curve = Curves.easeOutCubic,
    this.onLongPress,
    this.animationSpeed = 150,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      curve: curve,
      margin: EdgeInsets.all(visible ? 0.0 : 28.0),
      duration: Duration(milliseconds: animationSpeed),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          if (isOpen)
            AnimatedFloatingButtonLabel(
              tween: tween,
              label: label,
              animation: animation,
            ),
          GestureDetector(
            onLongPress: onLongPress,
            child: FloatingActionButton(
              child: visible ? child : null,
              backgroundColor: backgroundColor,
              foregroundColor: foregroundColor,
              onPressed: callback,
              tooltip: tooltip,
              heroTag: heroTag,
              elevation: elevation,
              highlightElevation: elevation,
              shape: shape,
            ),
          ),
        ],
      ),
    );
  }
}
