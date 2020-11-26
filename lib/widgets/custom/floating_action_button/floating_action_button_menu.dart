import 'package:flutter/material.dart';

import 'animated_child.dart';
import 'animated_floating_button.dart';
import 'background_overlay.dart';

/// Builds the Speed Dial
/// Source: https://pub.dev/packages/flutter_speed_dial
class FloatingActionButtonMenu extends StatefulWidget {
  /// Children buttons, from the lowest to the highest.
  final List<FloatingActionButtonMenuChild> children;

  /// Used to get the button hidden on scroll. See examples for more info.
  final bool visible;

  /// The curve used to animate the button on scrolling.
  final Curve curve;

  final String tooltip;
  final String label;
  final String heroTag;
  final Color backgroundColor;
  final Color foregroundColor;
  final double elevation;
  final ShapeBorder shape;

  final double marginRight;
  final double marginBottom;

  /// The color of the background overlay.
  final Color overlayColor;

  /// The opacity of the background overlay when the dial is open.
  final double overlayOpacity;

  /// The animated icon to show as the main button child. If this is provided the [child] is ignored.
  final AnimatedIconData animatedIcon;

  /// The theme for the animated icon.
  final IconThemeData animatedIconTheme;

  /// The child of the main button, ignored if [animatedIcon] is non-[null].
  final Widget child;

  /// Executed when the dial is opened.
  final VoidCallback onOpen;

  /// Executed when the dial is closed.
  final VoidCallback onClose;

  /// Executed when the dial is pressed. If given, the dial only opens on long press!
  final VoidCallback onPressed;

  /// If `true` [overlay] is not rendered and user is forced to close dial manually by tapping main button.
  final bool closeManually;

  /// The speed of the animation
  final int animationSpeed;

  final tween = Tween<double>(begin: 0.0, end: 62.0);

  FloatingActionButtonMenu({
    Key key,
    this.children = const [],
    this.visible = true,
    this.backgroundColor,
    this.foregroundColor,
    this.elevation = 6.0,
    this.overlayOpacity = 0.9,
    this.overlayColor = Colors.white,
    this.tooltip,
    this.label,
    this.heroTag,
    this.animatedIcon,
    this.animatedIconTheme,
    this.child,
    this.marginBottom = 16.0,
    this.marginRight = 14.0,
    this.onOpen,
    this.onClose,
    this.closeManually = false,
    this.shape = const CircleBorder(),
    this.curve = Curves.easeInOutCubic,
    this.onPressed,
    this.animationSpeed = 150,
  }) : super(key: key);

  @override
  _FloatingActionButtonMenuState createState() =>
      _FloatingActionButtonMenuState();
}

class _FloatingActionButtonMenuState extends State<FloatingActionButtonMenu>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;

  Animation<double> _childAnimation;

  bool _open = false;
  bool _animationCompleted = true;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: _calculateMainControllerDuration(),
      vsync: this,
    );

    _childAnimation = widget.tween.animate(
      CurvedAnimation(
        parent: _controller,
        curve: widget.curve,
      )..addStatusListener((status) {
          setState(() {
            _animationCompleted = status == AnimationStatus.completed ||
                status == AnimationStatus.dismissed;
          });
        }),
    );
  }

  @override
  void dispose() {
    _controller.dispose();

    super.dispose();
  }

  Duration _calculateMainControllerDuration() => Duration(
        milliseconds: widget.animationSpeed +
            widget.children.length * widget.animationSpeed ~/ 5,
      );

  void _performAnimation() {
    if (!mounted) return;

    if (_open) {
      _controller.forward();
    } else {
      _controller.reverse();
    }
  }

  @override
  void didUpdateWidget(FloatingActionButtonMenu oldWidget) {
    if (oldWidget.children.length != widget.children.length) {
      _controller.duration = _calculateMainControllerDuration();
    }

    super.didUpdateWidget(oldWidget);
  }

  void _toggleChildren() {
    var newOpenValue = !_open;

    setState(() => _open = newOpenValue);

    if (newOpenValue && widget.onOpen != null) widget.onOpen();

    _performAnimation();

    if (!newOpenValue && widget.onClose != null) widget.onClose();
  }

  List<Widget> _getChildrenList() {
    return widget.children
        .map((FloatingActionButtonMenuChild child) {
          var index = widget.children.indexOf(child);

          return AnimatedChild(
            tween: widget.tween,
            animation: _childAnimation,
            index: index,
            visible: _open,
            backgroundColor: child.backgroundColor ?? Colors.white,
            foregroundColor: child.foregroundColor ?? Colors.blue,
            elevation: child.elevation,
            icon: child.icon,
            label: child.label,
            labelStyle: child.labelStyle,
            labelBackgroundColor: child.labelBackgroundColor,
            labelWidget: child.labelWidget,
            onTap: child.onTap,
            toggleChildren: () {
              if (!widget.closeManually) _toggleChildren();
            },
            shape: child.shape,
            heroTag: widget.heroTag != null
                ? '${widget.heroTag}-child-$index'
                : null,
          );
        })
        .toList()
        .reversed
        .toList();
  }

  Widget _renderOverlay() {
    return Positioned(
      right: -16.0,
      bottom: -16.0,
      top: _open || !_animationCompleted ? 0.0 : null,
      left: _open || !_animationCompleted ? 0.0 : null,
      child: GestureDetector(
        onTap: _toggleChildren,
        child: BackgroundOverlay(
          animation: _controller,
          color: widget.overlayColor,
          opacity: widget.overlayOpacity,
        ),
      ),
    );
  }

  Widget _renderButton() {
    var child = widget.animatedIcon != null
        ? AnimatedIcon(
            icon: widget.animatedIcon,
            progress: _controller,
            color: widget.animatedIconTheme?.color,
            size: widget.animatedIconTheme?.size,
          )
        : widget.child;

    var fabChildren = _getChildrenList();

    Widget animatedFloatingButton = AnimatedFloatingButton(
      visible: widget.visible,
      tween: widget.tween,
      animation: _childAnimation,
      tooltip: widget.tooltip,
      label: widget.label,
      backgroundColor: widget.backgroundColor,
      foregroundColor: widget.foregroundColor,
      elevation: widget.elevation,
      isOpen: _open,
      onLongPress: _toggleChildren,
      callback: _open && widget.onPressed != null
          ? () {
              widget.onPressed();
              _toggleChildren();
            }
          : _toggleChildren,
      child: child,
      heroTag: widget.heroTag,
      shape: widget.shape,
      curve: widget.curve,
      animationSpeed: widget.animationSpeed,
    );

    return Positioned(
      bottom: widget.marginBottom - 16.0,
      right: widget.marginRight - 16.0,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: List.from(fabChildren)
          ..add(
            Container(
              margin: EdgeInsets.only(top: 8.0, right: 2.0),
              child: animatedFloatingButton,
            ),
          ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomRight,
      fit: StackFit.expand,
      clipBehavior: Clip.none,
      children: [
        if (!widget.closeManually) _renderOverlay(),
        _renderButton(),
      ],
    );
  }
}

/// Provides data for a speed dial child
class FloatingActionButtonMenuChild {
  /// The label to render to the left of the button
  final String label;

  /// The style of the label
  final TextStyle labelStyle;

  /// The background color of the label
  final Color labelBackgroundColor;

  /// If this is provided it will replace the default widget, therefore [label],
  /// [labelStyle] and [labelBackgroundColor] should be null
  final Widget labelWidget;

  final IconData icon;
  final Color backgroundColor;
  final Color foregroundColor;
  final double elevation;
  final VoidCallback onTap;
  final ShapeBorder shape;

  FloatingActionButtonMenuChild({
    this.label,
    this.labelStyle,
    this.labelBackgroundColor,
    this.labelWidget,
    this.icon,
    this.backgroundColor,
    this.foregroundColor,
    this.elevation,
    this.onTap,
    this.shape,
  });
}
