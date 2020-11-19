import 'package:cabin_booking/constants.dart';
import 'package:cabin_booking/l10n/app_localizations.dart';
import 'package:cabin_booking/model/booking.dart';
import 'package:cabin_booking/model/cabin.dart';
import 'package:cabin_booking/model/recurring_booking.dart';
import 'package:cabin_booking/widgets/booking/booking_popup_menu.dart';
import 'package:flutter/material.dart';
import 'package:timer_builder/timer_builder.dart';

class BookingCard extends StatelessWidget {
  final Cabin cabin;
  final Booking booking;

  BookingCard({@required this.cabin, @required this.booking});

  @override
  Widget build(BuildContext context) {
    final _isBeforeNow = booking.dateEnd.isBefore(DateTime.now());

    return TimerBuilder.periodic(
      Duration(minutes: 1),
      builder: (context) {
        final Widget _card = Card(
          margin: const EdgeInsets.all(8),
          shadowColor: _isBeforeNow ? Colors.black38 : Colors.black,
          color: booking is RecurringBooking && !booking.isDisabled
              ? Colors.yellow[100]
              : Colors.transparent,
          child: Container(
            height: booking.duration.inMinutes * bookingHeightRatio - 16,
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: _isBeforeNow
                  ? Color.fromARGB(150, 255, 255, 255)
                  : Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(4)),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(booking.studentName),
                      Text(
                        booking.timeRange,
                        style: TextStyle(color: Colors.black38),
                      ),
                    ],
                  ),
                ),
                BookingPopupMenu(
                  cabin: cabin,
                  booking: booking,
                ),
              ],
            ),
          ),
        );

        return booking.isDisabled
            ? Tooltip(
                message: AppLocalizations.of(context).disabled,
                child: _card,
              )
            : _card;
      },
    );
  }
}
