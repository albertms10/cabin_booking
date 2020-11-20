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

  Widget _buildLabel(BuildContext context) {
    final Animation<double> animation = listenable;

    if (!((label != null || labelWidget != null) &&
        visible &&
        animation.value > 62.0 / 2)) return Container();

    if (labelWidget != null) return labelWidget;

    return GestureDetector(
      onTap: _performAction,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 8.0),
        margin: const EdgeInsets.only(right: 18.0),
        child: Text(
          label,
          style: labelStyle ?? Theme.of(context).textTheme.subtitle2,
        ),
      ),
    );
  }

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
          _buildLabel(context),
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
