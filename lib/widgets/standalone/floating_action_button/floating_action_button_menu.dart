// ignore_for_file: avoid-returning-widgets

import 'package:flutter/material.dart';

import 'animated_child.dart';
import 'animated_floating_button.dart';
import 'background_overlay.dart';

/// Source: https://pub.dev/packages/flutter_speed_dial.
class FloatingActionButtonMenu extends StatefulWidget {
  /// Children buttons, from the lowest to the highest.
  final List<FloatingActionButtonMenuChild> buttons;

  /// Used to get the button hidden on scroll. See examples for more info.
  final bool visible;

  /// The curve used to animate the button on scrolling.
  final Curve curve;

  final String? tooltip;
  final Widget? label;
  final String? heroTag;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final double elevation;
  final ShapeBorder shape;

  final double marginEnd;
  final double marginBottom;

  /// The color of the background overlay.
  final Color? overlayColor;

  /// The opacity of the background overlay when the menu is open.
  final double overlayOpacity;

  /// The animated icon to show as the main button child.
  /// If this is provided the [child] is ignored.
  final AnimatedIconData? animatedIcon;

  /// The theme for the animated icon.
  final IconThemeData? animatedIconTheme;

  /// Executed when the menu is opened.
  final VoidCallback? onOpen;

  /// Executed when the menu is closed.
  final VoidCallback? onClose;

  /// Executed when the menu is pressed.
  /// If given, the menu only opens on long press.
  final VoidCallback? onPressed;

  /// If `true` [BackgroundOverlay] is not rendered and user is forced
  /// to close the menu manually by tapping main button.
  final bool closeManually;

  /// The speed of the animation.
  final int animationSpeed;

  final tween = Tween<double>(begin: 0, end: 62);

  /// The child of the main button, ignored if [animatedIcon] is non-null.
  final Widget? child;

  FloatingActionButtonMenu({
    super.key,
    required this.buttons,
    this.visible = true,
    this.backgroundColor,
    this.foregroundColor,
    this.elevation = 6,
    this.overlayOpacity = 0.9,
    this.overlayColor,
    this.tooltip,
    this.label,
    this.heroTag,
    this.animatedIcon,
    this.animatedIconTheme,
    this.marginBottom = 16,
    this.marginEnd = 14,
    this.onOpen,
    this.onClose,
    this.closeManually = false,
    this.shape = const CircleBorder(),
    this.curve = Curves.easeInOutCubic,
    this.onPressed,
    this.animationSpeed = 150,
    this.child,
  });

  @override
  State<FloatingActionButtonMenu> createState() =>
      _FloatingActionButtonMenuState();
}

class _FloatingActionButtonMenuState extends State<FloatingActionButtonMenu>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    duration: _calculateMainControllerDuration(),
    vsync: this,
  );

  late final Animation<double> _childAnimation = widget.tween.animate(
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

  bool _open = false;
  bool _animationCompleted = true;

  @override
  void dispose() {
    _controller.dispose();

    super.dispose();
  }

  Duration _calculateMainControllerDuration() => Duration(
        milliseconds: widget.animationSpeed +
            widget.buttons.length * widget.animationSpeed ~/ 5,
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
  void didUpdateWidget(covariant FloatingActionButtonMenu oldWidget) {
    if (oldWidget.buttons.length != widget.buttons.length) {
      _controller.duration = _calculateMainControllerDuration();
    }

    super.didUpdateWidget(oldWidget);
  }

  void _toggleChildren() {
    final newOpenValue = !_open;
    setState(() => _open = newOpenValue);

    if (newOpenValue) widget.onOpen?.call();
    _performAnimation();
    if (!newOpenValue) widget.onClose?.call();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: AlignmentDirectional.bottomEnd,
      fit: StackFit.expand,
      clipBehavior: Clip.none,
      children: [
        if (!widget.closeManually)
          _FloatingActionButtonOverlay(
            topStart: _open || !_animationCompleted ? 0.0 : null,
            bottomEnd: -16,
            color: widget.overlayColor,
            opacity: widget.overlayOpacity,
            animation: _controller,
            onTap: _toggleChildren,
          ),
        Positioned.directional(
          textDirection: Directionality.of(context),
          end: widget.marginEnd - 16,
          bottom: widget.marginBottom - 16,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: widget.buttons.reversed.map<Widget>((child) {
              final index = widget.buttons.indexOf(child);

              return AnimatedChild(
                animation: _childAnimation,
                tween: widget.tween,
                index: index,
                backgroundColor: child.backgroundColor,
                foregroundColor: child.foregroundColor,
                elevation: child.elevation,
                icon: child.icon,
                label: child.label,
                labelStyle: child.labelStyle,
                labelBackgroundColor: child.labelBackgroundColor,
                visible: _open,
                onTap: child.onTap,
                toggleChildren: () {
                  if (!widget.closeManually) _toggleChildren();
                },
                shape: child.shape,
                heroTag: widget.heroTag != null
                    ? '${widget.heroTag}-child-$index'
                    : null,
              );
            }).toList()
              ..add(
                Container(
                  margin: const EdgeInsetsDirectional.only(top: 8, end: 2),
                  child: AnimatedFloatingButton(
                    visible: widget.visible,
                    tween: widget.tween,
                    animation: _childAnimation,
                    callback: _open && widget.onPressed != null
                        ? () {
                            widget.onPressed?.call();
                            _toggleChildren();
                          }
                        : _toggleChildren,
                    backgroundColor: widget.backgroundColor,
                    foregroundColor: widget.foregroundColor,
                    tooltip: widget.tooltip,
                    label: widget.label,
                    heroTag: widget.heroTag,
                    elevation: widget.elevation,
                    isOpen: _open,
                    shape: widget.shape,
                    curve: widget.curve,
                    onLongPress: _toggleChildren,
                    animationSpeed: widget.animationSpeed,
                    child: widget.animatedIcon != null
                        ? AnimatedIcon(
                            icon: widget.animatedIcon!,
                            progress: _controller,
                            color: widget.animatedIconTheme?.color,
                            size: widget.animatedIconTheme?.size,
                          )
                        : widget.child,
                  ),
                ),
              ),
          ),
        ),
      ],
    );
  }
}

class _FloatingActionButtonOverlay extends StatelessWidget {
  final double? topStart;
  final double? bottomEnd;
  final Color? color;
  final double opacity;
  final Animation<double> animation;
  final VoidCallback? onTap;

  const _FloatingActionButtonOverlay({
    super.key,
    this.topStart,
    this.bottomEnd,
    this.color,
    this.opacity = 0.9,
    required this.animation,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned.directional(
      textDirection: Directionality.of(context),
      start: topStart,
      top: topStart,
      end: bottomEnd,
      bottom: bottomEnd,
      child: GestureDetector(
        onTap: onTap,
        child: BackgroundOverlay(
          animation: animation,
          color: color,
          opacity: opacity,
        ),
      ),
    );
  }
}

/// Provides data for Floating Action Button Menu child.
class FloatingActionButtonMenuChild {
  final Widget? label;
  final TextStyle? labelStyle;
  final Color? labelBackgroundColor;

  final IconData? icon;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final double? elevation;
  final VoidCallback? onTap;
  final ShapeBorder? shape;

  const FloatingActionButtonMenuChild({
    this.label,
    this.labelStyle,
    this.labelBackgroundColor,
    this.icon,
    this.backgroundColor,
    this.foregroundColor,
    this.elevation,
    this.onTap,
    this.shape,
  });
}
