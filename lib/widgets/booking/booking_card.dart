import 'package:cabin_booking/constants.dart';
import 'package:cabin_booking/model.dart';
import 'package:cabin_booking/widgets/booking/booking_preview_panel_overlay.dart';
import 'package:cabin_booking/widgets/layout/scrollable_time_table.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:timer_builder/timer_builder.dart';

class BookingCard extends StatelessWidget {
  final Cabin cabin;
  final Booking booking;
  final ShowPreviewOverlayCallback? showPreviewPanel;
  final SetPreventTimeTableScroll? setPreventTimeTableScroll;

  const BookingCard({
    super.key,
    required this.cabin,
    required this.booking,
    this.showPreviewPanel,
    this.setPreventTimeTableScroll,
  });

  double get height => booking.duration.inMinutes * kBookingHeightRatio - 16;

  @override
  Widget build(BuildContext context) {
    final isBeforeNow = booking.endDate!.isBefore(DateTime.now());

    return TimerBuilder.periodic(
      const Duration(minutes: 1),
      builder: (context) {
        return TweenAnimationBuilder<double>(
          tween: Tween<double>(begin: height, end: height),
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOutCubic,
          builder: (context, value, child) {
            return Card(
              shadowColor: isBeforeNow ? Colors.black38 : Colors.black87,
              elevation: 0,
              shape: RoundedRectangleBorder(
                side: BorderSide(
                  color: Colors.grey[300]!.withOpacity(isBeforeNow ? 0.41 : 1),
                  width: 1.5,
                ),
                borderRadius: const BorderRadius.all(Radius.circular(10)),
              ),
              margin: const EdgeInsets.all(8),
              child: Container(
                decoration: booking.isLocked
                    ? BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        gradient: const LinearGradient(
                          begin: AlignmentDirectional.topStart,
                          end: Alignment(-0.4, -0.2),
                          colors: [
                            Color.fromARGB(16, 0, 0, 0),
                            Color.fromARGB(16, 0, 0, 0),
                            Colors.white10,
                            Colors.white10,
                          ],
                          stops: [0, 0.5, 0.5, 1],
                          tileMode: TileMode.repeated,
                        ),
                      )
                    : BoxDecoration(
                        color: Theme.of(context)
                            .cardColor
                            .withOpacity(isBeforeNow ? 0.41 : 1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                height: height,
                child: _BookingCardInteractive(
                  cabin: cabin,
                  booking: booking,
                  height: value,
                  showPreviewPanel: showPreviewPanel,
                  setPreventTimeTableScroll: setPreventTimeTableScroll,
                ),
              ),
            );
          },
        );
      },
    );
  }
}

class _BookingCardInteractive extends StatefulWidget {
  final Cabin cabin;
  final Booking booking;
  final double height;
  final ShowPreviewOverlayCallback? showPreviewPanel;
  final SetPreventTimeTableScroll? setPreventTimeTableScroll;

  const _BookingCardInteractive({
    super.key,
    required this.cabin,
    required this.booking,
    required this.height,
    this.showPreviewPanel,
    this.setPreventTimeTableScroll,
  });

  bool get isRecurring => RecurringBooking.isRecurringBooking(booking);

  @override
  _BookingCardInteractiveState createState() => _BookingCardInteractiveState();
}

class _BookingCardInteractiveState extends State<_BookingCardInteractive> {
  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: InkWell(
        onTap: () {
          final renderBox = context.findRenderObject() as RenderBox?;
          if (renderBox == null) return;
          widget.showPreviewPanel?.call(
            widget.cabin,
            widget.booking,
            renderBox,
            widget.setPreventTimeTableScroll,
          );
        },
        customBorder: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        child: Padding(
          padding: const EdgeInsetsDirectional.only(start: 10, top: 8, end: 4),
          child: _BookingCardInfo(
            cabin: widget.cabin,
            booking: widget.booking,
            isRecurring: widget.isRecurring,
          ),
        ),
      ),
    );
  }
}

class _BookingCardInfo extends StatelessWidget {
  final Cabin cabin;
  final Booking booking;
  final bool isRecurring;

  const _BookingCardInfo({
    super.key,
    required this.cabin,
    required this.booking,
    this.isRecurring = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appLocalizations = AppLocalizations.of(context)!;

    return LayoutBuilder(
      builder: (context, constraints) {
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (isRecurring)
              Tooltip(
                message:
                    '${booking.recurringNumber}/${booking.recurringTotalTimes}',
                child: Padding(
                  padding: const EdgeInsetsDirectional.only(end: 4),
                  child: Icon(Icons.repeat, size: 16, color: theme.hintColor),
                ),
              ),
            Expanded(
              child: Padding(
                padding: const EdgeInsetsDirectional.only(end: 28),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      !booking.isLocked
                          ? booking.description!
                          : '${booking.description} '
                              '(${appLocalizations.locked.toLowerCase()})',
                      style: TextStyle(
                        fontSize: constraints.maxHeight > 20
                            ? 14
                            : constraints.maxHeight * 0.5,
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 4,
                    ),
                    if (constraints.maxHeight > 30)
                      Text(
                        booking.timeRange,
                        style: theme.textTheme.caption?.copyWith(
                          fontSize: constraints.maxHeight > 40
                              ? 14
                              : constraints.maxHeight * 0.4,
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
