import 'package:flutter/material.dart';

import 'animated_floating_button_label.dart';

class AnimatedChild extends AnimatedWidget {
  final int? index;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final double? elevation;
  final IconData? icon;
  final Tween<double> tween;

  final Widget? label;
  final TextStyle? labelStyle;
  final Color? labelBackgroundColor;

  final bool visible;
  final VoidCallback? onTap;
  final VoidCallback? toggleChildren;
  final ShapeBorder? shape;
  final String? heroTag;

  const AnimatedChild({
    super.key,
    required Animation<double> animation,
    required this.tween,
    this.index,
    this.backgroundColor,
    this.foregroundColor,
    this.elevation = 6,
    this.icon,
    this.label,
    this.labelStyle,
    this.labelBackgroundColor,
    this.visible = false,
    this.onTap,
    this.toggleChildren,
    this.shape,
    this.heroTag,
  }) : super(listenable: animation);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final animation = listenable as Animation<double>;

    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        AnimatedFloatingButtonLabel(
          label: label,
          tween: tween,
          animation: animation,
        ),
        SizedBox(
          width: tween.end,
          height: animation.value,
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 10),
            width: animation.value,
            height: tween.end,
            child: FloatingActionButton(
              foregroundColor: foregroundColor ?? theme.colorScheme.secondary,
              backgroundColor: backgroundColor ?? theme.dialogBackgroundColor,
              heroTag: heroTag,
              elevation: elevation,
              onPressed: () {
                onTap?.call();
                toggleChildren?.call();
              },
              child: animation.value > 50
                  ? SizedBox(
                      width: animation.value,
                      height: animation.value,
                      child: Icon(icon, size: animation.value / 3),
                    )
                  : const SizedBox(),
            ),
          ),
        ),
      ],
    );
  }
}
