import 'package:cabin_booking/widgets/booking/bookings_table.dart';
import 'package:cabin_booking/widgets/cabin/cabins_icons_row.dart';
import 'package:flutter/material.dart';

class TimeTable extends StatelessWidget {
  const TimeTable();

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          const CabinsIconsRow(),
          const Divider(height: 1),
          Expanded(
            child: ListView(
              key: const PageStorageKey('BookingsListView'),
              children: const [
                Padding(
                  padding: EdgeInsets.only(top: 16.0),
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
