import 'package:cabin_booking/widgets/layout/conditional_widget_wrap.dart';
import 'package:flutter/material.dart';

class BookingPreviewPanelRow extends StatelessWidget {
  final Widget? trailing;
  final Widget? child;

  const BookingPreviewPanelRow({
    super.key,
    this.trailing,
    this.child,
  });

  const factory BookingPreviewPanelRow.headline({
    Key? key,
    Widget? trailing,
    required String headline,
    Widget? description,
  }) = _BookingPreviewPanelRowHeadline;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _BookingPreviewPanelRowTrailing(child: trailing),
        if (child != null) Expanded(child: child!),
      ],
    );
  }
}

class _BookingPreviewPanelRowHeadline extends BookingPreviewPanelRow {
  final String headline;

  const _BookingPreviewPanelRowHeadline({
    super.key,
    super.trailing,
    required this.headline,
    Widget? description,
  }) : super(child: description);

  @override
  Widget build(BuildContext context) {
    return ConditionalWidgetWrap(
      condition: child != null,
      conditionalBuilder: (rowChild) {
        return Column(
          children: [
            rowChild,
            BookingPreviewPanelRow(child: child),
          ],
        );
      },
      child: Row(
        children: [
          _BookingPreviewPanelRowTrailing(
            iconSize: 26,
            child: trailing,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  headline,
                  style: Theme.of(context)
                      .textTheme
                      .headline5
                      ?.copyWith(fontWeight: FontWeight.w300),
                ),
                const SizedBox(height: 4),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _BookingPreviewPanelRowTrailing extends StatelessWidget {
  final double iconSize;
  final Widget? child;

  const _BookingPreviewPanelRowTrailing({
    super.key,
    this.iconSize = 20.0,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 60,
      child: child != null
          ? SizedBox(
              width: iconSize,
              height: iconSize,
              child: IconTheme.merge(
                data: IconThemeData(
                  size: iconSize,
                  color: Theme.of(context).hintColor,
                ),
                child: Center(child: child),
              ),
            )
          : null,
    );
  }
}
