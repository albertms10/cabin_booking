import 'package:cabin_booking/l10n/app_localizations.dart';
import 'package:cabin_booking/model/booking.dart';
import 'package:cabin_booking/model/cabin.dart';
import 'package:cabin_booking/model/cabin_manager.dart';
import 'package:cabin_booking/widgets/booking/booking_dialog.dart';
import 'package:cabin_booking/widgets/booking/delete_booking_dialog.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BookingPopupMenu extends StatelessWidget {
  final Cabin cabin;
  final Booking booking;

  BookingPopupMenu({
    @required this.cabin,
    @required this.booking,
  });

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      onSelected: (choice) async {
        final cabinManager = Provider.of<CabinManager>(context, listen: false);

        switch (choice) {
          case 'edit':
            final _booking = await showDialog<Booking>(
              context: context,
              builder: (context) => BookingDialog(booking),
            );

            if (_booking != null)
              cabinManager.modifyBooking(cabin.id, _booking);
            break;

          case 'delete':
            final _shallDelete = await showDialog<bool>(
              context: context,
              builder: (context) => DeleteBookingDialog(),
            );

            if (_shallDelete)
              cabinManager.removeBookingById(cabin.id, booking.id);

            break;
        }
      },
      icon: const Icon(
        Icons.more_vert,
        size: 16,
        color: Colors.black54,
      ),
      itemBuilder: (BuildContext context) {
        return {'edit', 'delete'}.map((String choice) {
          return PopupMenuItem(
            value: choice,
            child: Text(
              AppLocalizations.of(context).getValue(choice),
              style: const TextStyle(fontSize: 14),
            ),
            height: 36,
          );
        }).toList();
      },
    );
  }
}
