import 'package:cabin_booking/constants.dart';
import 'package:cabin_booking/model/cabin_manager.dart';
import 'package:cabin_booking/utils/compactize_range.dart';
import 'package:cabin_booking/widgets/cabin/cabins_table.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CabinsPage extends StatelessWidget {
  const CabinsPage();

  @override
  Widget build(BuildContext context) {
    return Consumer<CabinManager>(
      builder: (context, cabinManager, child) {
        return CabinsTable(
          cabinRows: [
            for (final cabin in cabinManager.cabins)
              CabinTableRow(
                id: cabin.id,
                number: cabin.number,
                components: cabin.components,
                bookingsCount: cabin.bookings.length,
                recurringBookingsCount:
                    cabin.generatedBookingsFromRecurring.length,
                accumulatedDuration: cabin.accumulatedDuration,
                occupancyRate: cabin.occupiedRatio(
                  startTime: timeTableStartTime,
                  endTime: timeTableEndTime,
                  dates: cabinManager.allCabinsDatesWithBookings,
                ),
                mostOccupiedTimeRanges: compactizeRange<TimeOfDay>(
                  cabin.mostOccupiedTimeRanges.toSet(),
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
