import 'package:flutter/material.dart';

class AnimatedFloatingButton extends StatelessWidget {
  final bool visible;
  final VoidCallback callback;
  final VoidCallback onLongPress;
  final Widget child;
  final Color backgroundColor;
  final Color foregroundColor;
  final String tooltip;
  final String label;
  final String heroTag;
  final double elevation;
  final bool isOpen;
  final ShapeBorder shape;
  final Curve curve;

  AnimatedFloatingButton({
    this.visible = true,
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
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      child: AnimatedContainer(
        curve: curve,
        margin: EdgeInsets.all(visible ? 0.0 : 28.0),
        duration: Duration(milliseconds: 150),
        child: Container(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              if (isOpen)
                Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: 5.0,
                    horizontal: 8.0,
                  ),
                  margin: const EdgeInsets.only(right: 18.0),
                  child: Text(
                    label,
                    style: Theme.of(context).textTheme.subtitle2,
                  ),
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
        ),
      ),
    );
  }
}
