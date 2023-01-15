import 'package:cabin_booking/model.dart';
import 'package:cabin_booking/widgets/booking/booking_dialog.dart';
import 'package:cabin_booking/widgets/layout/danger_alert_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

class BookingPreviewPanelActionBar extends StatelessWidget {
  final Cabin cabin;
  final Booking booking;
  final VoidCallback? onClose;

  const BookingPreviewPanelActionBar({
    required this.cabin,
    required this.booking,
    super.key,
    this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    final materialLocalizations = MaterialLocalizations.of(context);

    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        _BookingPreviewEditIconButton(
          cabin: cabin,
          booking: booking,
          onClose: onClose,
        ),
        _BookingPreviewDeleteIconButton(
          cabin: cabin,
          booking: booking,
          onClose: onClose,
        ),
        const SizedBox(width: 16),
        _BookingPreviewIconButton(
          onPressed: onClose,
          tooltip: materialLocalizations.closeButtonTooltip,
          icon: Icons.close,
        ),
      ],
    );
  }
}

class _BookingPreviewIconButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final String? tooltip;
  final IconData icon;

  const _BookingPreviewIconButton({
    super.key,
    this.onPressed,
    this.tooltip,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      iconSize: 20,
      splashRadius: 18,
      color: Theme.of(context).hintColor,
      onPressed: onPressed,
      tooltip: tooltip,
      icon: Icon(icon),
    );
  }
}

class _BookingPreviewEditIconButton extends StatelessWidget {
  final Cabin cabin;
  final Booking booking;
  final VoidCallback? onClose;

  const _BookingPreviewEditIconButton({
    super.key,
    required this.cabin,
    required this.booking,
    this.onClose,
  });

  Future<void> _onEdit(BuildContext context) async {
    final cabinCollection =
        Provider.of<CabinCollection>(context, listen: false);

    final bookingToEdit = booking is RecurringBooking
        ? cabinCollection
            .cabinFromId(cabin.id)
            .bookingCollection
            .recurringBookingFromId(booking.id)
        : booking;

    final editedBooking = await showDialog<Booking>(
      context: context,
      builder: (context) => BookingDialog(
        booking: bookingToEdit.copyWith(cabin: cabin),
      ),
    );

    if (editedBooking == null) return;

    if (RecurringBooking.isRecurringBooking(editedBooking)) {
      if (RecurringBooking.isRecurringBooking(booking)) {
        cabinCollection.modifyRecurringBooking(
          cabin.id,
          editedBooking as RecurringBooking,
        );
      } else {
        cabinCollection.changeSingleToRecurringBooking(
          cabin.id,
          editedBooking as RecurringBooking,
        );
      }
    } else {
      if (RecurringBooking.isRecurringBooking(booking)) {
        cabinCollection.changeRecurringToSingleBooking(
          cabin.id,
          editedBooking as SingleBooking,
        );
      } else {
        cabinCollection.modifySingleBooking(
          cabin.id,
          editedBooking as SingleBooking,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final appLocalizations = AppLocalizations.of(context)!;

    return _BookingPreviewIconButton(
      onPressed: () async {
        onClose?.call();
        await _onEdit(context);
      },
      tooltip: appLocalizations.edit,
      icon: Icons.edit_outlined,
    );
  }
}

class _BookingPreviewDeleteIconButton extends StatelessWidget {
  final Cabin cabin;
  final Booking booking;
  final VoidCallback? onClose;

  const _BookingPreviewDeleteIconButton({
    super.key,
    required this.cabin,
    required this.booking,
    this.onClose,
  });

  Future<void> _onDelete(BuildContext context) async {
    final appLocalizations = AppLocalizations.of(context)!;

    final cabinCollection =
        Provider.of<CabinCollection>(context, listen: false);

    final shallDelete = await showDialog<bool>(
      context: context,
      builder: (context) => DangerAlertDialog(
        title: appLocalizations.deleteBookingTitle,
        content: appLocalizations.actionUndone,
      ),
    );

    if (shallDelete == null || !shallDelete) return;

    if (booking is RecurringBookingOccurrence) {
      cabinCollection.removeRecurringBookingById(
        cabin.id,
        (booking as RecurringBookingOccurrence).recurringBooking?.id,
      );
    } else {
      cabinCollection.removeSingleBookingById(cabin.id, booking.id);
    }
  }

  @override
  Widget build(BuildContext context) {
    final materialLocalizations = MaterialLocalizations.of(context);

    return _BookingPreviewIconButton(
      onPressed: () async {
        onClose?.call();
        await _onDelete(context);
      },
      tooltip: materialLocalizations.deleteButtonTooltip,
      icon: Icons.delete_outlined,
    );
  }
}
