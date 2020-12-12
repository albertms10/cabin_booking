import 'package:cabin_booking/widgets/layout/day_navigation.dart';
import 'package:cabin_booking/widgets/layout/school_year_dropdown.dart';
import 'package:flutter/material.dart';

class BookingDateNavigation extends StatelessWidget {
  const BookingDateNavigation();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      color: Colors.grey[50],
      child: Row(
        children: const [
          Expanded(child: DayNavigation()),
          SchoolYearDropdown(),
        ],
      ),
    );
  }
}
