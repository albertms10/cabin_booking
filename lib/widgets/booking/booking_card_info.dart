import 'package:cabin_booking/model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class BookingCardInfo extends StatelessWidget {
  final Cabin cabin;
  final Booking booking;

  const BookingCardInfo({
    super.key,
    required this.cabin,
    required this.booking,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appLocalizations = AppLocalizations.of(context)!;

    return Padding(
      padding: const EdgeInsetsDirectional.only(start: 10, top: 8, end: 4),
      child: LayoutBuilder(
        builder: (context, constraints) {
          return Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (booking is RecurringBookingOccurrence)
                _BookingCardRecurringIcon(
                  booking: booking as RecurringBookingOccurrence,
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
                          booking.textualTime,
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
      ),
    );
  }
}

class _BookingCardRecurringIcon extends StatelessWidget {
  final RecurringBookingOccurrence booking;

  const _BookingCardRecurringIcon({super.key, required this.booking});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Tooltip(
      message:
          '${booking.recurringNumber}/${booking.recurringBooking?.occurrences}',
      child: Padding(
        padding: const EdgeInsetsDirectional.only(end: 4),
        child: Icon(Icons.repeat, size: 16, color: theme.hintColor),
      ),
    );
  }
}
