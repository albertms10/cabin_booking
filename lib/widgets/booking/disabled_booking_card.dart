import 'package:cabin_booking/constants.dart';
import 'package:cabin_booking/model/booking.dart';
import 'package:cabin_booking/model/cabin.dart';
import 'package:cabin_booking/widgets/booking/booking_popup_menu.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class DisabledBookingCard extends StatelessWidget {
  final Cabin cabin;
  final Booking booking;

  const DisabledBookingCard({
    Key key,
    @required this.cabin,
    @required this.booking,
  }) : super(key: key);

  double get height => booking.duration.inMinutes * kBookingHeightRatio - 16.0;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(8.0),
      child: Tooltip(
        message: '${booking.description} '
            '(${AppLocalizations.of(context).disabled.toLowerCase()})',
        child: InkWell(
          onTap: () {},
          mouseCursor: MouseCursor.defer,
          borderRadius: const BorderRadius.all(Radius.circular(4.0)),
          child: Container(
            height: height,
            padding: const EdgeInsets.all(8.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Expanded(child: SizedBox()),
                BookingPopupMenu(
                  cabin: cabin,
                  booking: booking,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
