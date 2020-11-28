import 'package:cabin_booking/constants.dart';
import 'package:cabin_booking/model/cabin_manager.dart';
import 'package:cabin_booking/model/day_handler.dart';
import 'package:cabin_booking/widgets/cabin/cabin_icon.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CabinsRow extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey[50],
      padding: const EdgeInsets.symmetric(vertical: 24.0),
      child: Consumer2<DayHandler, CabinManager>(
        builder: (context, dayHandler, cabinManager, child) {
          return Row(
            children: [
              child,
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
