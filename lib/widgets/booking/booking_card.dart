import 'package:cabin_booking/constants.dart';
import 'package:cabin_booking/model.dart';
import 'package:cabin_booking/widgets/booking/booking_popup_menu.dart';
import 'package:cabin_booking/widgets/booking/booking_status_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:timer_builder/timer_builder.dart';

class BookingCard extends StatelessWidget {
  final Cabin cabin;
  final Booking booking;

  const BookingCard({
    Key? key,
    required this.cabin,
    required this.booking,
  }) : super(key: key);

  double get height => booking.duration.inMinutes * kBookingHeightRatio - 16.0;

  @override
  Widget build(BuildContext context) {
    return TimerBuilder.periodic(
      const Duration(minutes: 1),
      builder: (context) {
        return TweenAnimationBuilder<double>(
          tween: Tween<double>(begin: height, end: height),
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOutCubic,
          builder: (context, value, child) {
            return _BookingCardBody(
              cabin: cabin,
              booking: booking,
              height: value,
            );
          },
        );
      },
    );
  }
}

class _BookingCardBody extends StatefulWidget {
  final Cabin cabin;
  final Booking booking;
  final double height;

  const _BookingCardBody({
    Key? key,
    required this.cabin,
    required this.booking,
    required this.height,
  }) : super(key: key);

  bool get isRecurring => RecurringBooking.isRecurringBooking(booking);

  @override
  _BookingCardBodyState createState() => _BookingCardBodyState();
}

class _BookingCardBodyState extends State<_BookingCardBody> {
  @override
  Widget build(BuildContext context) {
    final isBeforeNow = widget.booking.endDateTime.isBefore(DateTime.now());

    return Card(
      margin: const EdgeInsets.all(8.0),
      shadowColor: isBeforeNow ? Colors.black38 : Colors.black87,
      elevation: 0.0,
      shape: RoundedRectangleBorder(
        borderRadius: const BorderRadius.all(Radius.circular(10.0)),
        side: BorderSide(
          color: Colors.grey[300]!.withOpacity(isBeforeNow ? 0.41 : 1.0),
          width: 1.5,
        ),
      ),
      color: Colors.transparent,
      child: Container(
        height: widget.height,
        padding: const EdgeInsets.only(
          top: 8.0,
          right: 4.0,
          left: 10.0,
        ),
        decoration: (!widget.booking.isLocked)
            ? BoxDecoration(
                color: Theme.of(context)
                    .cardColor
                    .withOpacity(isBeforeNow ? 0.41 : 1.0),
                borderRadius: BorderRadius.circular(10.0),
              )
            : BoxDecoration(
                borderRadius: BorderRadius.circular(10.0),
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment(-0.4, -0.2),
                  stops: [0.0, 0.5, 0.5, 1.0],
                  colors: [
                    Color.fromARGB(16, 0, 0, 0),
                    Color.fromARGB(16, 0, 0, 0),
                    Colors.white10,
                    Colors.white10,
                  ],
                  tileMode: TileMode.repeated,
                ),
              ),
        child: _BookingCardInfo(
          cabin: widget.cabin,
          booking: widget.booking,
          isRecurring: widget.isRecurring,
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
    Key? key,
    required this.cabin,
    required this.booking,
    this.isRecurring = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appLocalizations = AppLocalizations.of(context)!;

    return LayoutBuilder(
      builder: (context, constraints) {
        return Stack(
          alignment: Alignment.topRight,
          children: [
            Row(
              children: [
                if (isRecurring)
                  Tooltip(
                    message:
                        '${booking.recurringNumber}/${booking.recurringTotalTimes}',
                    child: Padding(
                      padding: const EdgeInsets.only(right: 4.0),
                      child: Icon(
                        Icons.repeat,
                        color: theme.hintColor,
                        size: 16.0,
                      ),
                    ),
                  ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(right: 28.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          !booking.isLocked
                              ? booking.description!
                              : '${booking.description} '
                                  '(${appLocalizations.locked.toLowerCase()})',
                          style: TextStyle(
                            fontSize: constraints.maxHeight > 20.0
                                ? 14.0
                                : constraints.maxHeight * 0.5,
                          ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 4,
                        ),
                        if (constraints.maxHeight > 30.0)
                          Text(
                            booking.timeRange,
                            style: theme.textTheme.caption?.copyWith(
                              fontSize: constraints.maxHeight > 40.0
                                  ? 14.0
                                  : constraints.maxHeight * 0.4,
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: double.infinity,
              child: SizedBox(
                width: 48,
                child: Wrap(
                  direction: Axis.vertical,
                  alignment: WrapAlignment.spaceBetween,
                  spacing: -8.0,
                  runAlignment: WrapAlignment.center,
                  runSpacing: -8.0,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    BookingPopupMenu(
                      cabin: cabin,
                      booking: booking,
                    ),
                    if (!booking.isLocked)
                      BookingStatusButton(
                        status: booking.status,
                        onPressed: () {
                          Provider.of<CabinManager>(context, listen: false)
                              .modifyBookingStatusById(
                            cabin.id,
                            booking.id,
                            BookingStatus.values[(booking.status.index + 1) %
                                BookingStatus.values.length],
                          );
                        },
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
