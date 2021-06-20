import 'package:cabin_booking/widgets/layout/day_navigation.dart';
import 'package:cabin_booking/widgets/layout/school_year_dropdown.dart';
import 'package:flutter/material.dart';

class BookingDateNavigation extends StatelessWidget {
  const BookingDateNavigation({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      color: Theme.of(context).dialogBackgroundColor,
      child: Row(
        children: const [
          Expanded(child: DayNavigation()),
          SchoolYearDropdown(),
        ],
      ),
    );
  }
}
