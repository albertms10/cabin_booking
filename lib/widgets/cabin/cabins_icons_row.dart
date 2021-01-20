import 'package:cabin_booking/constants.dart';
import 'package:cabin_booking/model/cabin_manager.dart';
import 'package:cabin_booking/model/day_handler.dart';
import 'package:cabin_booking/widgets/cabin/cabin_icon.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

class CabinsIconsRow extends StatelessWidget {
  const CabinsIconsRow();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      color: theme.dialogBackgroundColor,
      padding: const EdgeInsets.symmetric(vertical: 24.0),
      child: Consumer2<DayHandler, CabinManager>(
        builder: (context, dayHandler, cabinManager, child) {
          return Row(
            children: [
              child,
              if (cabinManager.cabins.isEmpty)
                Expanded(
                  child: Text(
                    AppLocalizations.of(context).noCabins,
                    textAlign: TextAlign.center,
                    style: theme.textTheme.headline5
                        .copyWith(color: Colors.grey[600]),
                  ),
                )
              else
                for (final cabin in cabinManager.cabins)
                  SizedBox(
                    width: kColumnWidth,
                    child: CabinIcon(
                      number: cabin.number,
                      progress: cabin.occupancyPercentOn(
                        dayHandler.dateTime,
                        startTime: kTimeTableStartTime,
                        endTime: kTimeTableEndTime,
                      ),
                    ),
                  ),
            ],
          );
        },
        child: const SizedBox(width: kColumnWidth),
      ),
    );
  }
}
