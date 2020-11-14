import 'package:cabin_booking/model/cabin.dart';
import 'package:cabin_booking/model/day_handler.dart';
import 'package:cabin_booking/widgets/booking/bookings_stack.dart';
import 'package:cabin_booking/widgets/layout/current_time_indicator.dart';
import 'package:cabin_booking/widgets/layout/stripped_background.dart';
import 'package:cabin_booking/widgets/layout/time_column.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BookingsTable extends StatelessWidget {
  final List<Cabin> cabins;

  BookingsTable({this.cabins = const []});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        StrippedBackground(count: 8),
        Consumer<DayHandler>(
          builder: (context, dayHandler, child) {
            return Row(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: TimeColumn(start: 15, end: 22),
                ),
                for (int cabin = 0; cabin < cabins.length; cabin++)
                  Expanded(
                    child: BookingsStack(
                      bookings: cabins[cabin]
                          .bookings
                          .where(
                            (booking) =>
                                booking.dateStart.year ==
                                    dayHandler.dateTime.year &&
                                booking.dateStart.month ==
                                    dayHandler.dateTime.month &&
                                booking.dateStart.day ==
                                    dayHandler.dateTime.day,
                          )
                          .toList(),
                    ),
                  ),
              ],
            );
          },
        ),
        CurrentTimeIndicator(),
      ],
    );
  }
}
