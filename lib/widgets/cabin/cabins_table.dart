import 'package:cabin_booking/model.dart';
import 'package:cabin_booking/utils/iterable_extension.dart';
import 'package:cabin_booking/utils/map_extension.dart';
import 'package:cabin_booking/utils/time_of_day_extension.dart';
import 'package:cabin_booking/widgets/cabin/cabin_dialog.dart';
import 'package:cabin_booking/widgets/item/items_table.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

class CabinsTable extends StatelessWidget {
  const CabinsTable({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<CabinManager>(
      builder: (context, cabinManager, child) {
        final appLocalizations = AppLocalizations.of(context)!;

        final now = DateTime.now();
        final dateRange = DateRange(
          startDate: now.subtract(const Duration(days: 365)),
          endDate: now,
        );
        final keysToFill = dateRange.dateTimeList(
          interval: const Duration(days: DateTime.daysPerWeek),
        );

        return ItemsTable<Cabin>(
          itemIcon: Icons.sensor_door,
          itemHeaderLabel: appLocalizations.cabin,
          rows: [
            for (final cabin in cabinManager.cabins)
              ItemsTableRow<Cabin>(
                item: cabin,
                bookingsCount: cabin.bookings.length,
                recurringBookingsCount:
                    cabin.generatedBookingsFromRecurring.length,
                occupiedDuration: cabin.occupiedDuration(),
                occupiedDurationPerWeek:
                    cabin.occupiedDurationPerWeek(dateRange)
                      ..fillEmptyKeyValues(
                        keys: keysToFill,
                        ifAbsent: () => Duration.zero,
                      ),
                mostOccupiedTimeRanges: cabin
                    .mostOccupiedTimeRange()
                    .compactConsecutive(
                      nextValue: (timeOfDay) => timeOfDay.increment(hours: 1),
                      inclusive: true,
                    )
                    .toSet(),
              ),
          ],
          emptyMessage: appLocalizations.noCabinsMessage,
          onEditPressed: (selectedRows) async {
            final editedCabin = await showDialog<Cabin>(
              context: context,
              builder: (context) => CabinDialog(cabin: selectedRows.first.item),
            );

            if (editedCabin != null) {
              cabinManager.modifyCabin(editedCabin);
            }
          },
          onEmptyTitle: appLocalizations.emptyCabinTitle,
          onEmptyPressed: (selectedIds) =>
              cabinManager.emptyCabinsByIds(selectedIds),
          onRemoveTitle: appLocalizations.deleteCabinTitle,
          onRemovePressed: (selectedIds) =>
              cabinManager.removeCabinsByIds(selectedIds),
        );
      },
    );
  }
}
