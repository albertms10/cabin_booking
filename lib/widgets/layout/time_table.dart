import 'package:cabin_booking/model/data/cabin_data.dart';
import 'package:cabin_booking/widgets/booking/booking_stack.dart';
import 'package:cabin_booking/widgets/cabin/cabins_row.dart';
import 'package:cabin_booking/widgets/layout/stripped_background.dart';
import 'package:cabin_booking/widgets/layout/time_column.dart';
import 'package:flutter/material.dart';

class TimeTable extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CabinsRow(cabins: cabins),
        Stack(
          children: [
            StrippedBackground(count: 8),
            Row(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: TimeColumn(start: 15, end: 22),
                ),
                for (int cabin = 0; cabin < cabins.length; cabin++)
                  Expanded(
                    child: BookingStack(bookings: cabins[cabin].bookings),
                  ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
