import 'package:cabin_booking/model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class DayNavigation extends StatelessWidget {
  const DayNavigation({super.key});

  @override
  Widget build(BuildContext context) {
    final appLocalizations = AppLocalizations.of(context)!;

    return Consumer<DayHandler>(
      builder: (context, dayHandler, child) {
        return Wrap(
          spacing: 8,
          runSpacing: 8,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            TextButton(
              onPressed: () => dayHandler.changeToNow(),
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: Text(appLocalizations.today),
            ),
            Material(
              type: MaterialType.transparency,
              shape: const CircleBorder(),
              clipBehavior: Clip.antiAlias,
              child: IconButton(
                onPressed: dayHandler.hasPreviousDay
                    ? () => dayHandler.changeToPreviousDay()
                    : null,
                tooltip: appLocalizations.previousDay,
                icon: const Icon(Icons.chevron_left),
              ),
            ),
            Material(
              type: MaterialType.transparency,
              shape: const CircleBorder(),
              clipBehavior: Clip.antiAlias,
              child: IconButton(
                onPressed: dayHandler.hasNextDay
                    ? () => dayHandler.changeToNextDay()
                    : null,
                tooltip: appLocalizations.nextDay,
                icon: const Icon(Icons.chevron_right),
              ),
            ),
            const SizedBox(width: 8),
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
    super.key,
    this.isNonSchoolDay = false,
  });

  @override
  Widget build(BuildContext context) {
    final appLocalizations = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          spacing: 8,
          runSpacing: 4,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            Text(
              DateFormat.EEEE().format(dateTime),
              style: theme.textTheme.headline5,
            ),
            if (isNonSchoolDay)
              Chip(
                label: Text(appLocalizations.nonSchoolDay),
                visualDensity: const VisualDensity(vertical: -4),
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
