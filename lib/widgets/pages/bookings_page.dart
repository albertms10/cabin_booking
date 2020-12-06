import 'package:cabin_booking/widgets/layout/day_navigation.dart';
import 'package:cabin_booking/widgets/layout/time_table.dart';
import 'package:flutter/material.dart';

class BookingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        DayNavigation(),
        TimeTable(),
      ],
    );
  }
}
