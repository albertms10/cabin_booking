import 'package:flutter/widgets.dart';

/// Conditionally wrap a subtree with a parent widget without breaking
/// the code tree.
///
/// See [source Gist](https://gist.github.com/ltOgt/3771c824fc1c8811f5ec1a81a9a4937b).
///
/// ___________
/// Use:
///
/// ```dart
/// return ConditionalParentWidget(
///   condition: shouldIncludeParent,
///   child: Widget1(
///     child: Widget2(
///       child: Widget3(),
///     ),
///   ),
///   conditionalBuilder: (Widget child) => SomeParentWidget(child: child),
///);
/// ```
///
/// ___________
/// Instead of:
///
/// ```dart
/// Widget child = Widget1(
///   child: Widget2(
///     child: Widget3(),
///   ),
/// );
///
/// return shouldIncludeParent ? SomeParentWidget(child: child) : child;
/// ```
class ConditionalWidgetWrap extends StatelessWidget {
  /// The subtree that should always be build.
  final Widget child;

  /// The condition depending on which the subtree [child]
  /// is wrapped with the parent.
  final bool condition;

  /// Builds the parent with the subtree [child].
  final Widget Function(Widget) conditionalBuilder;

  const ConditionalWidgetWrap({
    required this.child,
    required this.condition,
    required this.conditionalBuilder,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    if (condition) return conditionalBuilder(child);

    return child;
  }
}
