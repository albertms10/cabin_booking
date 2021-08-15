import 'package:cabin_booking/model/booking.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class BookingStatusButton extends StatelessWidget {
  final BookingStatus status;
  final VoidCallback? onPressed;

  const BookingStatusButton({
    Key? key,
    required this.status,
    this.onPressed,
  }) : super(key: key);

  Map<BookingStatus, String> _statusMessages(BuildContext context) {
    final appLocalizations = AppLocalizations.of(context)!;

    return {
      BookingStatus.pending: appLocalizations.pending,
      BookingStatus.confirmed: appLocalizations.confirmed,
      BookingStatus.cancelled: appLocalizations.cancelled,
    };
  }

  Map<BookingStatus, Color> _statusColors(BuildContext context) => {
        BookingStatus.pending: Theme.of(context).hintColor,
        BookingStatus.confirmed:
            Theme.of(context).brightness == Brightness.light
                ? Colors.greenAccent[700]!
                : Colors.greenAccent,
        BookingStatus.cancelled: Colors.redAccent,
      };

  Map<BookingStatus, IconData> get _statusIcons => {
        BookingStatus.pending: Icons.help,
        BookingStatus.confirmed: Icons.check,
        BookingStatus.cancelled: Icons.clear,
      };

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: _statusMessages(context)[status]!,
      child: Material(
        color: Colors.transparent,
        shape: const StadiumBorder(),
        child: IconButton(
          padding: EdgeInsets.zero,
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
