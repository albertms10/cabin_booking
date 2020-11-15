import 'package:cabin_booking/l10n/app_localizations.dart';
import 'package:cabin_booking/model/booking.dart';
import 'package:cabin_booking/model/cabin.dart';
import 'package:cabin_booking/model/cabin_manager.dart';
import 'package:cabin_booking/widgets/booking/booking_dialog.dart';
import 'package:cabin_booking/widgets/booking/delete_booking_dialog.dart';
import 'package:cabin_booking/widgets/layout/icon_menu_item_content.dart';
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
              builder: (context) => BookingDialog(
                booking..cabinId = cabin.id,
              ),
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
        return [
          PopupMenuItem(
            value: 'edit',
            child: IconMenuItemContent(
              text: AppLocalizations.of(context).edit,
              icon: Icons.edit,
            ),
            height: 41,
          ),
          PopupMenuItem(
            value: 'delete',
            child: IconMenuItemContent(
              text: MaterialLocalizations.of(context).deleteButtonTooltip,
              icon: Icons.delete,
            ),
            height: 41,
          )
        ];
      },
    );
  }
}
