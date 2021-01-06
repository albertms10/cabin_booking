import 'package:cabin_booking/constants.dart';
import 'package:cabin_booking/model/cabin.dart';
import 'package:cabin_booking/model/cabin_manager.dart';
import 'package:cabin_booking/utils/compactize_range.dart';
import 'package:cabin_booking/widgets/cabin/cabin_dialog.dart';
import 'package:cabin_booking/widgets/item/items_table.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

class CabinsTable extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<CabinManager>(
      builder: (context, cabinManager, child) {
        final appLocalizations = AppLocalizations.of(context);

        return ItemsTable(
          itemTitle: (row) => '${row.item.number}',
          itemIcon: Icons.sensor_door,
          itemHeaderLabel: appLocalizations.cabin,
          emptyMessage: appLocalizations.noCabinsMessage,
          onEditPressed: (selectedRows) async {
            final selectedCabin = selectedRows.first;

            final editedCabin = await showDialog<Cabin>(
              context: context,
              builder: (context) => CabinDialog(
                cabin: selectedCabin.item,
              ),
            );

            if (editedCabin != null) {
              cabinManager.modifyCabin(editedCabin);
            }
          },
          onEmptyPressed: (selectedIds) =>
              cabinManager.emptyCabinsByIds(selectedIds),
          onRemovePressed: (selectedIds) =>
              cabinManager.removeCabinsByIds(selectedIds),
          rows: [
            for (final cabin in cabinManager.cabins)
              ItemsTableRow<Cabin>(
                item: cabin,
                bookingsCount: cabin.bookings.length,
                recurringBookingsCount:
                    cabin.generatedBookingsFromRecurring.length,
                accumulatedDuration: cabin.occupiedDuration(),
                occupancyPercent: cabin.occupancyPercent(
                  startTime: kTimeTableStartTime,
                  endTime: kTimeTableEndTime,
                  dates: cabinManager.allCabinsDatesWithBookings(),
                ),
                mostOccupiedTimeRanges: compactizeRange<TimeOfDay>(
                  cabin.mostOccupiedTimeRange(),
                  nextValue: (timeOfDay) => timeOfDay.replacing(
                    hour: (timeOfDay.hour + 1) % TimeOfDay.hoursPerDay,
                  ),
                  inclusive: true,
                ),
              ),
          ],
        );
      },
    );
  }
}
