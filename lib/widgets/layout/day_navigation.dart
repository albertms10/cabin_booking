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
            Material(
              type: MaterialType.transparency,
              clipBehavior: Clip.antiAlias,
              shape: const CircleBorder(),
              child: IconButton(
                onPressed: dayHandler.hasPreviousDay
                    ? () => dayHandler.changeToPreviousDay()
                    : null,
                icon: const Icon(Icons.chevron_left),
                tooltip: appLocalizations.previousDay,
              ),
            ),
            Material(
              type: MaterialType.transparency,
              clipBehavior: Clip.antiAlias,
              shape: const CircleBorder(),
              child: IconButton(
                onPressed: dayHandler.hasNextDay
                    ? () => dayHandler.changeToNextDay()
                    : null,
                icon: const Icon(Icons.chevron_right),
                tooltip: appLocalizations.nextDay,
              ),
            ),
            const SizedBox(width: 8.0),
            _WeekDateTime(
              dateTime: dayHandler.dateTime,
              isNonSchoolDay: dayHandler.dateTimeIsNonSchool,
            ),
          ],
        );
      },
    );
  }
}

class _WeekDateTime extends StatelessWidget {
  final DateTime dateTime;
  final bool isNonSchoolDay;

  const _WeekDateTime({
    required this.dateTime,
    Key? key,
    this.isNonSchoolDay = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final appLocalizations = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          spacing: 8.0,
          runSpacing: 4.0,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            Text(
              DateFormat.EEEE().format(dateTime),
              style: theme.textTheme.headline5,
            ),
            if (isNonSchoolDay)
              Chip(
                label: Text(appLocalizations.nonSchoolDay),
                visualDensity: const VisualDensity(vertical: -4.0),
              ),
          ],
        ),
        Text(
          DateFormat.yMMMMd().format(dateTime),
          style: theme.textTheme.subtitle2?.copyWith(color: theme.hintColor),
        ),
      ],
    );
  }
}
