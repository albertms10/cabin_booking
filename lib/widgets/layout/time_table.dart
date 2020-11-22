import 'package:cabin_booking/widgets/booking/bookings_table.dart';
import 'package:cabin_booking/widgets/cabin/cabins_row.dart';
import 'package:flutter/material.dart';

class TimeTable extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          CabinsRow(),
          Divider(height: 1),
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
    );
  }
}
