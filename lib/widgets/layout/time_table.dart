import 'package:cabin_booking/l10n/app_localizations.dart';
import 'package:cabin_booking/model/cabin_manager.dart';
import 'package:cabin_booking/widgets/booking/bookings_table.dart';
import 'package:cabin_booking/widgets/cabin/cabins_row.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TimeTable extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final cabinManager = Provider.of<CabinManager>(context, listen: false);

    cabinManager.addListener(() async {
      await cabinManager.writeCabinsToFile();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context).changesSaved),
        ),
      );
    });

    return FutureBuilder(
      future: cabinManager.loadCabinsFromFile(),
      builder: (context, snapshot) {
        return snapshot.hasError
            ? Expanded(
                child: Center(
                  child: Text(
                    AppLocalizations.of(context).dataCouldNotBeLoaded,
                    style: Theme.of(context).textTheme.headline4,
                  ),
                ),
              )
            : snapshot.hasData
                ? Expanded(
                    child: Column(
                      children: [
                        CabinsRow(),
                        Expanded(
                          child: ListView(
                            children: [
                              Container(
                                padding: const EdgeInsets.only(top: 16.0),
                                child: BookingsTable(),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  )
                : const Expanded(
                    child: Center(child: CircularProgressIndicator()),
                  );
      },
    );
  }
}
