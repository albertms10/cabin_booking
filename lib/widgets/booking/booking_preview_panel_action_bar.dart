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
          icon: Icons.close,
          onPressed: onClose,
          tooltip: materialLocalizations.closeButtonTooltip,
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
      onPressed: onPressed,
      tooltip: tooltip,
      icon: Icon(icon),
      color: Theme.of(context).hintColor,
      iconSize: 20,
      splashRadius: 18,
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
    final cabinManager = Provider.of<CabinManager>(context, listen: false);

    final editedBooking = await showDialog<Booking>(
      context: context,
      builder: (context) => BookingDialog(
        booking: (booking.recurringBookingId == null
            ? booking
            : cabinManager
                .cabinFromId(cabin.id)
                .recurringBookingFromId(booking.recurringBookingId!))
          ..cabinId = cabin.id,
      ),
    );

    if (editedBooking == null) return;

    if (RecurringBooking.isRecurringBooking(editedBooking)) {
      if (RecurringBooking.isRecurringBooking(booking)) {
        cabinManager.modifyRecurringBooking(
          cabin.id,
          editedBooking as RecurringBooking,
        );
      } else {
        cabinManager.changeSingleToRecurringBooking(
          cabin.id,
          editedBooking as SingleBooking,
        );
      }
    } else {
      if (RecurringBooking.isRecurringBooking(booking)) {
        cabinManager.changeRecurringToSingleBooking(
          cabin.id,
          editedBooking as RecurringBooking,
        );
      } else {
        cabinManager.modifySingleBooking(
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
      icon: Icons.edit_outlined,
      onPressed: () async {
        onClose?.call();
        await _onEdit(context);
      },
      tooltip: appLocalizations.edit,
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

    final cabinManager = Provider.of<CabinManager>(context, listen: false);

    final shallDelete = await showDialog<bool>(
      context: context,
      builder: (context) => DangerAlertDialog(
        title: appLocalizations.deleteBookingTitle,
        content: appLocalizations.actionUndone,
      ),
    );

    if (shallDelete == null || !shallDelete) return;

    if (RecurringBooking.isRecurringBooking(booking)) {
      cabinManager.removeRecurringBookingById(
        cabin.id,
        booking.recurringBookingId,
      );
    } else {
      cabinManager.removeSingleBookingById(cabin.id, booking.id);
    }
  }

  @override
  Widget build(BuildContext context) {
    final materialLocalizations = MaterialLocalizations.of(context);

    return _BookingPreviewIconButton(
      icon: Icons.delete_outlined,
      onPressed: () async {
        onClose?.call();
        await _onDelete(context);
      },
      tooltip: materialLocalizations.deleteButtonTooltip,
    );
  }
}
