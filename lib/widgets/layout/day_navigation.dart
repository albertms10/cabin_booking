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

    final dayHandler = Provider.of<DayHandler>(context, listen: false);
    final splashRadius = 22.0;

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          FlatButton(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            onPressed: () => dayHandler.changeToNow(),
            child: Text(appLocalizations.today),
          ),
          IconButton(
            onPressed: () => dayHandler.changeToPreviousDay(),
            icon: const Icon(Icons.chevron_left),
            tooltip: appLocalizations.previousDay,
            splashRadius: splashRadius,
          ),
          IconButton(
            onPressed: () => dayHandler.changeToNextDay(),
            icon: const Icon(Icons.chevron_right),
            tooltip: appLocalizations.nextDay,
            splashRadius: splashRadius,
          ),
          const SizedBox(width: 24.0),
          Consumer<DayHandler>(
            builder: (context, dayHandler, child) {
              return Text(
                DateFormat.MMMMEEEEd().format(dayHandler.dateTime),
                style: Theme.of(context)
                    .textTheme
                    .headline5
                    .copyWith(color: Colors.black87),
              );
            },
          ),
        ],
      ),
    );
  }
}
