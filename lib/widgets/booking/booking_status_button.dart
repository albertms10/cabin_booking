import 'package:cabin_booking/model/booking.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class BookingStatusButton extends StatelessWidget {
  final BookingStatus status;
  final void Function()? onPressed;

  const BookingStatusButton({
    Key? key,
    required this.status,
    this.onPressed,
  }) : super(key: key);

  Map<BookingStatus, String> _statusMessages(BuildContext context) {
    final appLocalizations = AppLocalizations.of(context)!;

    return {
      BookingStatus.Pending: appLocalizations.pending,
      BookingStatus.Confirmed: appLocalizations.confirmed,
      BookingStatus.Cancelled: appLocalizations.cancelled,
    };
  }

  Map<BookingStatus, Color?> _statusColors(BuildContext context) => {
        BookingStatus.Pending: Theme.of(context).hintColor,
        BookingStatus.Confirmed:
            Theme.of(context).brightness == Brightness.light
                ? Colors.greenAccent[700]
                : Colors.greenAccent,
        BookingStatus.Cancelled: Colors.redAccent,
      };

  Map<BookingStatus, IconData> get _statusIcons => {
        BookingStatus.Pending: Icons.help,
        BookingStatus.Confirmed: Icons.check,
        BookingStatus.Cancelled: Icons.clear,
      };

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: _statusMessages(context)[status]!,
      child: Material(
        color: Colors.transparent,
        shape: const StadiumBorder(),
        child: IconButton(
          padding: const EdgeInsets.all(0.0),
          icon: Icon(_statusIcons[status]),
          iconSize: 14.0,
          splashRadius: 14.0,
          color: _statusColors(context)[status],
          onPressed: onPressed,
        ),
      ),
    );
  }
}
