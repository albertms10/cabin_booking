import 'package:cabin_booking/widgets/booking/booking_date_navigation.dart';
import 'package:cabin_booking/widgets/layout/scrollable_time_table.dart';
import 'package:flutter/material.dart';

class BookingsPage extends StatefulWidget {
  const BookingsPage({super.key});

  @override
  _BookingsPageState createState() => _BookingsPageState();
}

class _BookingsPageState extends State<BookingsPage>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Column(
      children: const [
        BookingDateNavigation(),
        ScrollableTimeTable(),
      ],
    );
  }
}
