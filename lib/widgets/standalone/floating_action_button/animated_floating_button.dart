import 'package:flutter/material.dart';

import 'animated_floating_button_label.dart';

class AnimatedFloatingButton extends StatelessWidget {
  final bool visible;
  final Tween<double> tween;
  final Animation<double> animation;
  final VoidCallback? callback;
  final VoidCallback? onLongPress;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final String? tooltip;
  final Widget? label;
  final String? heroTag;
  final double elevation;
  final bool isOpen;
  final ShapeBorder shape;
  final Curve curve;
  final int animationSpeed;
  final Widget? child;

  const AnimatedFloatingButton({
    super.key,
    this.visible = true,
    required this.tween,
    required this.animation,
    this.callback,
    this.backgroundColor,
    this.foregroundColor,
    this.tooltip,
    this.label,
    this.heroTag,
    this.elevation = 6,
    this.isOpen = false,
    this.shape = const CircleBorder(),
    this.curve = Curves.easeOutCubic,
    this.onLongPress,
    this.animationSpeed = 150,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      margin: EdgeInsets.all(visible ? 0 : 28),
      curve: curve,
      duration: Duration(milliseconds: animationSpeed),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          if (isOpen)
            AnimatedFloatingButtonLabel(
              label: label,
              tween: tween,
              animation: animation,
            ),
          GestureDetector(
            onLongPress: onLongPress,
            child: FloatingActionButton(
              tooltip: tooltip,
              foregroundColor: foregroundColor,
              backgroundColor: backgroundColor,
              heroTag: heroTag,
              elevation: elevation,
              highlightElevation: elevation,
              onPressed: callback,
              shape: shape,
              child: visible ? child : null,
            ),
          ),
        ],
      ),
    );
  }
}
