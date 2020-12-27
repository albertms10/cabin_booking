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
    return Container(
      color: Theme.of(context).dialogBackgroundColor,
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
                    style: Theme.of(context)
                        .textTheme
                        .headline5
                        .copyWith(color: Colors.grey[600]),
                  ),
                )
              else
                for (final cabin in cabinManager.cabins)
                  SizedBox(
                    width: columnWidth,
                    child: CabinIcon(
                      number: cabin.number,
                      progress: cabin.occupiedRatioOn(
                        dayHandler.dateTime,
                        startTime: timeTableStartTime,
                        endTime: timeTableEndTime,
                      ),
                    ),
                  ),
            ],
          );
        },
        child: const SizedBox(width: columnWidth),
      ),
    );
  }
}
