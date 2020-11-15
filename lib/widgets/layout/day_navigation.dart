import 'package:cabin_booking/l10n/app_localizations.dart';
import 'package:cabin_booking/model/day_handler.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class DayNavigation extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final _dayHandler = Provider.of<DayHandler>(context, listen: false);

    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          FlatButton(
            padding: const EdgeInsets.symmetric(vertical: 16),
            onPressed: () => _dayHandler.now(),
            child: Text(AppLocalizations.of(context).today),
          ),
          IconButton(
            onPressed: () => _dayHandler.previousDay(),
            icon: const Icon(Icons.chevron_left),
            tooltip: AppLocalizations.of(context).previousDay,
            splashRadius: 22,
          ),
          IconButton(
            onPressed: () => _dayHandler.nextDay(),
            icon: const Icon(Icons.chevron_right),
            tooltip: AppLocalizations.of(context).nextDay,
            splashRadius: 22,
          ),
          SizedBox(width: 24),
          Consumer<DayHandler>(
            builder: (context, dayHandler, child) {
              return Text(
                DateFormat.MMMMd().format(dayHandler.dateTime),
                style: Theme.of(context)
                    .textTheme
                    .headline5
                    .copyWith(color: Colors.black87),
              );
            },
          )
        ],
      ),
    );
  }
}
