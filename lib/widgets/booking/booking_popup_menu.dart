import 'package:cabin_booking/model/booking.dart';
import 'package:cabin_booking/model/cabin.dart';
import 'package:cabin_booking/model/cabin_manager.dart';
import 'package:cabin_booking/model/recurring_booking.dart';
import 'package:cabin_booking/widgets/booking/booking_dialog.dart';
import 'package:cabin_booking/widgets/layout/danger_alert_dialog.dart';
import 'package:cabin_booking/widgets/layout/icon_menu_item_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

class BookingPopupMenu extends StatelessWidget {
  final Cabin? cabin;
  final Booking booking;

  const BookingPopupMenu({
    required this.cabin,
    required this.booking,
  });

  void _onEditSelected(BuildContext context) async {
    final cabinManager = Provider.of<CabinManager>(context, listen: false);

    final editedBooking = await showDialog<Booking>(
      context: context,
      builder: (context) => BookingDialog(
        (booking.recurringBookingId == null
            ? booking
            : cabinManager
                .cabinFromId(cabin!.id)
                .recurringBookingFromId(booking.recurringBookingId))
          ..cabinId = cabin!.id,
      ),
    );

    if (editedBooking == null) return;

    if (RecurringBooking.isRecurringBooking(editedBooking)) {
      if (RecurringBooking.isRecurringBooking(booking)) {
        cabinManager.modifyRecurringBooking(
          cabin!.id,
          editedBooking as RecurringBooking,
        );
      } else {
        cabinManager.changeBookingToRecurring(
          cabin!.id,
          editedBooking as RecurringBooking,
        );
      }
    } else {
      if (RecurringBooking.isRecurringBooking(booking)) {
        cabinManager.changeRecurringToBooking(
          cabin!.id,
          editedBooking,
        );
      } else {
        cabinManager.modifyBooking(cabin!.id, editedBooking);
      }
    }
  }

  void _onDeleteSelected(BuildContext context) async {
    final appLocalizations = AppLocalizations.of(context);

    final cabinManager = Provider.of<CabinManager>(context, listen: false);

    final shallDelete = await showDialog<bool>(
      context: context,
      builder: (context) => DangerAlertDialog(
        title: appLocalizations!.deleteBookingTitle,
        content: appLocalizations.actionUndone,
      ),
    );

    if (shallDelete == null || !shallDelete) return;

    if (RecurringBooking.isRecurringBooking(booking)) {
      cabinManager.removeRecurringBookingById(
        cabin!.id,
        booking.recurringBookingId,
      );
    } else {
      cabinManager.removeBookingById(cabin!.id, booking.id);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.all(Radius.circular(24.0)),
      child: Material(
        color: Colors.transparent,
        child: PopupMenuButton<String>(
          onSelected: (choice) {
            switch (choice) {
              case 'edit':
                _onEditSelected(context);
                break;

              case 'delete':
                _onDeleteSelected(context);
                break;
            }
          },
          itemBuilder: (context) {
            const height = 41.0;

            return [
              PopupMenuItem(
                value: 'edit',
                height: height,
                child: IconMenuItemContent(
                  text: AppLocalizations.of(context)!.edit,
                  icon: Icons.edit,
                ),
              ),
              PopupMenuItem(
                value: 'delete',
                height: height,
                child: IconMenuItemContent(
                  text: MaterialLocalizations.of(context).deleteButtonTooltip,
                  icon: Icons.delete,
                ),
              ),
            ];
          },
          child: Padding(
            padding: const EdgeInsets.all(6.0),
            child: Icon(
              Icons.more_vert,
              size: 18.0,
              color: Theme.of(context).hintColor,
            ),
          ),
        ),
      ),
    );
  }
}
