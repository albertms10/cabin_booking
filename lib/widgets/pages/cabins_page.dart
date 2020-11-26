import 'package:cabin_booking/constants.dart';
import 'package:cabin_booking/model/cabin.dart';
import 'package:cabin_booking/model/cabin_manager.dart';
import 'package:cabin_booking/widgets/cabin/cabins_table.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CabinsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 182),
      child: SingleChildScrollView(
        child: Consumer<CabinManager>(
          builder: (context, cabinManager, child) {
            return CabinsTable(
              cabinRows: [
                for (Cabin cabin in cabinManager.cabins)
                  CabinTableRow(
                    number: cabin.number,
                    bookingsCount: cabin.bookings.length,
                    recurringBookingsCount: cabin.recurringBookings.length,
                    occupancyRate: cabin.evertimeOccupiedRatio(
                      startTime: timeTableStartTime,
                      endTime: timeTableEndTime,
                      dates: cabinManager.allCabinsDatesWithBookings(),
                    ),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }
}
