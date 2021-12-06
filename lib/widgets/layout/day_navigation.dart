import 'package:cabin_booking/model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class DayNavigation extends StatelessWidget {
  const DayNavigation({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final appLocalizations = AppLocalizations.of(context)!;

    return Consumer<DayHandler>(
      builder: (context, dayHandler, child) {
        return Wrap(
          crossAxisAlignment: WrapCrossAlignment.center,
          spacing: 8.0,
          runSpacing: 8.0,
          children: [
            TextButton(
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
              ),
              onPressed: () => dayHandler.changeToNow(),
              child: Text(appLocalizations.today),
            ),
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
            const SizedBox(width: 8.0),
            _WeekDateTime(dateTime: dayHandler.dateTime),
          ],
        );
      },
    );
  }
}

class _WeekDateTime extends StatelessWidget {
  final DateTime dateTime;

  const _WeekDateTime({required this.dateTime, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          DateFormat.EEEE().format(dateTime),
          style: Theme.of(context).textTheme.headline5,
        ),
        Text(
          DateFormat.yMMMMd().format(dateTime),
          style: Theme.of(context)
              .textTheme
              .subtitle2!
              .copyWith(color: Colors.white70),
        ),
      ],
    );
  }
}
