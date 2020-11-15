import 'package:cabin_booking/widgets/booking/bookings_table.dart';
import 'package:cabin_booking/widgets/cabin/cabins_row.dart';
import 'package:cabin_booking/widgets/layout/day_navigation.dart';
import 'package:flutter/material.dart';

class TimeTable extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          DayNavigation(),
          CabinsRow(),
          BookingsTable(),
        ],
      ),
    );
  }
}
