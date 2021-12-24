import 'package:cabin_booking/model.dart';
import 'package:cabin_booking/widgets/booking/booking_preview_panel.dart';
import 'package:cabin_booking/widgets/layout/scrollable_time_table.dart';
import 'package:flutter/material.dart';

typedef ShowPreviewOverlayCallback = void Function(
  Cabin,
  Booking,
  RenderBox,
  SetPreventTimeTableScroll? setPreventTimeTableScroll,
);

typedef PanelOverlayBuilder = Widget Function(
  BuildContext,
  ShowPreviewOverlayCallback showPreviewPanel,
);

class BookingPreviewPanelOverlay extends StatefulWidget {
  final double width;
  final PanelOverlayBuilder builder;

  const BookingPreviewPanelOverlay({
    Key? key,
    required this.builder,
    this.width = 400.0,
  }) : super(key: key);

  @override
  _BookingPreviewPanelOverlayState createState() =>
      _BookingPreviewPanelOverlayState();
}

class _BookingPreviewPanelOverlayState
    extends State<BookingPreviewPanelOverlay> {
  String? _lastBookingId;

  final LayerLink _layerLink = LayerLink();
  OverlayEntry? _overlayEntry;

  Offset _resolvedOffsetFromContext(BuildContext context, RenderBox renderBox) {
    final offset = renderBox.localToGlobal(Offset.zero);

    final containerRenderBox = context.findRenderObject()! as RenderBox;
    final containerOffset = containerRenderBox.localToGlobal(Offset.zero);

    return offset - containerOffset;
  }

  Offset _desiredOffset({
    required Offset offset,
    required Size screenSize,
    required Size overlaySize,
    required Size renderBoxSize,
  }) {
    final dx = offset.dx > screenSize.width * 0.5
        ? -overlaySize.width
        : renderBoxSize.width;

    return offset + Offset(dx, -5.0);
  }

  void _showPreviewPanel(
    Cabin cabin,
    Booking booking,
    RenderBox renderBox,
    SetPreventTimeTableScroll? setPreventTimeTableScroll,
  ) {
    if (_overlayEntry != null) _hidePreviewPanel(resetPrevious: false);

    if (_lastBookingId == booking.id) {
      _lastBookingId = null;
      setPreventTimeTableScroll?.call(value: false);

      return;
    }

    _lastBookingId = booking.id;

    final resolvedOffset = _resolvedOffsetFromContext(context, renderBox);

    setPreventTimeTableScroll?.call(value: true);

    _overlayEntry = OverlayEntry(
      builder: (context) {
        return Stack(
          children: [
            GestureDetector(
              onTap: () {
                _hidePreviewPanel(
                  setPreventTimeTableScroll: setPreventTimeTableScroll,
                );
              },
              behavior: HitTestBehavior.translucent,
            ),
            Positioned(
              width: widget.width,
              child: CompositedTransformFollower(
                link: _layerLink,
                showWhenUnlinked: false,
                offset: _desiredOffset(
                  offset: resolvedOffset,
                  screenSize: MediaQuery.of(context).size,
                  overlaySize: Size(widget.width, 200.0),
                  renderBoxSize: renderBox.size,
                ),
                child: _AnimatedOffsetBuilder(
                  duration: const Duration(milliseconds: 200),
                  builder: (context, offset) {
                    return SlideTransition(
                      position: offset,
                      child: Card(
                        elevation: 24.0,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10.0)),
                        ),
                        color: Theme.of(context).scaffoldBackgroundColor,
                        child: BookingPreviewPanel(
                          cabin: cabin,
                          booking: booking,
                          onClose: () {
                            _hidePreviewPanel(
                              setPreventTimeTableScroll:
                                  setPreventTimeTableScroll,
                            );
                          },
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        );
      },
    );

    Overlay.of(context)?.insert(_overlayEntry!);
  }

  void _hidePreviewPanel({
    bool resetPrevious = true,
    SetPreventTimeTableScroll? setPreventTimeTableScroll,
  }) {
    if (_overlayEntry == null) return;

    if (resetPrevious) {
      _lastBookingId = null;
      setPreventTimeTableScroll?.call(value: false);
    }

    _overlayEntry!.remove();
    _overlayEntry = null;
  }

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: _layerLink,
      child: widget.builder(context, _showPreviewPanel),
    );
  }
}

class _AnimatedOffsetBuilder extends StatefulWidget {
  final Duration duration;
  final Curve curve;
  final Widget Function(BuildContext, Animation<Offset>) builder;

  const _AnimatedOffsetBuilder({
    Key? key,
    required this.duration,
    this.curve = Curves.easeInOutCubic,
    required this.builder,
  }) : super(key: key);

  @override
  _AnimatedOffsetBuilderState createState() => _AnimatedOffsetBuilderState();
}

class _AnimatedOffsetBuilderState extends State<_AnimatedOffsetBuilder>
    with TickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    duration: widget.duration,
    vsync: this,
  )..forward();

  late final Animation<double> _opacity =
      Tween<double>(begin: 0.0, end: 1.0).animate(
    CurvedAnimation(parent: _controller, curve: widget.curve),
  );

  late final Animation<Offset> _offset = Tween<Offset>(
    begin: const Offset(-0.03, 0.0),
    end: Offset.zero,
  ).animate(
    CurvedAnimation(parent: _controller, curve: widget.curve),
  );

  @override
  void dispose() {
    _controller.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _opacity,
      child: widget.builder(context, _offset),
    );
  }
}
