import 'package:cabin_booking/constants.dart';
import 'package:cabin_booking/model/cabin_manager.dart';
import 'package:cabin_booking/model/day_handler.dart';
import 'package:cabin_booking/widgets/booking/bookings_stack.dart';
import 'package:cabin_booking/widgets/layout/current_time_indicator.dart';
import 'package:cabin_booking/widgets/layout/stripped_background.dart';
import 'package:cabin_booking/widgets/layout/time_column.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BookingsTable extends StatelessWidget {
  const BookingsTable();

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return Stack(
        children: [
          const StrippedBackground(
            startTime: kTimeTableStartTime,
            endTime: kTimeTableEndTime,
          ),
          Consumer2<DayHandler, CabinManager>(
            builder: (context, dayHandler, cabinManager, child) {
              final maxParentWidth = constraints.maxWidth;
              final bookingStackWidth = (maxParentWidth - kTimeColumnWidth) /
                  cabinManager.cabins.length;

              return Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  child,
                  for (final cabin in cabinManager.cabins)
                    SizedBox(
                      width: (bookingStackWidth > kBookingColumnMaxWidth)
                          ? kBookingColumnMaxWidth
                          : bookingStackWidth,
                      child: BookingsStack(
                        key: Key('${cabin.number}'),
                        cabin: cabin.simplified(),
                        bookings: cabin.allBookingsOn(dayHandler.dateTime),
                      ),
                    ),
                ],
              );
            },
            child: const TimeColumn(),
          ),
          const CurrentTimeIndicator(),
        ],
      );
    });
  }
}
