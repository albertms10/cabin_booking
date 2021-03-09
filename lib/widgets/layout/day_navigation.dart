import 'package:cabin_booking/model/day_handler.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class DayNavigation extends StatelessWidget {
  const DayNavigation();

  @override
  Widget build(BuildContext context) {
    final appLocalizations = AppLocalizations.of(context);

    return Consumer<DayHandler>(
      builder: (context, dayHandler, child) {
        return Row(
          children: [
            TextButton(
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
              ),
              onPressed: () => dayHandler.changeToNow(),
              child: Text(appLocalizations!.today),
            ),
            const SizedBox(width: 8.0),
            ClipRRect(
              borderRadius: const BorderRadius.all(Radius.circular(24.0)),
              child: Material(
                child: IconButton(
                  onPressed: dayHandler.hasPreviousDay
                      ? () => dayHandler.changeToPreviousDay()
                      : null,
                  icon: const Icon(Icons.chevron_left),
                  tooltip: appLocalizations.previousDay,
                ),
              ),
            ),
            const SizedBox(width: 8.0),
            ClipRRect(
              borderRadius: const BorderRadius.all(Radius.circular(24.0)),
              child: Material(
                child: IconButton(
                  onPressed: dayHandler.hasNextDay
                      ? () => dayHandler.changeToNextDay()
                      : null,
                  icon: const Icon(Icons.chevron_right),
                  tooltip: appLocalizations.nextDay,
                ),
              ),
            ),
            const SizedBox(width: 24.0),
            Text(
              DateFormat.yMMMMEEEEd().format(dayHandler.dateTime),
              style: Theme.of(context).textTheme.headline5,
            ),
          ],
        );
      },
    );
  }
}
