import 'package:cabin_booking/model/data/cabin_data.dart';
import 'package:cabin_booking/model/day_handler.dart';
import 'package:cabin_booking/widgets/booking/bookings_table.dart';
import 'package:cabin_booking/widgets/cabin/cabins_row.dart';
import 'package:cabin_booking/widgets/layout/day_navigation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TimeTable extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: ChangeNotifierProvider<DayHandler>(
        create: (context) => DayHandler(),
        child: Column(
          children: [
            DayNavigation(),
            CabinsRow(cabins: cabins),
            BookingsTable(cabins: cabins),
          ],
        ),
      ),
    );
  }
}
