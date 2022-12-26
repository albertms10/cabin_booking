import 'package:cabin_booking/model.dart';
import 'package:cabin_booking/utils/dialog.dart';
import 'package:cabin_booking/widgets/jump_bar/booking_search_result.dart';
import 'package:cabin_booking/widgets/jump_bar/jump_bar_item.dart';
import 'package:cabin_booking/widgets/pages/home_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class JumpBarResults extends StatelessWidget {
  final SingleBooking? suggestedBooking;
  final List<Booking>? searchedBookings;
  final double itemExtent;
  final BuildContext homePageContext;

  const JumpBarResults({
    super.key,
    this.suggestedBooking,
    this.searchedBookings,
    required this.itemExtent,
    required this.homePageContext,
  });

  @override
  Widget build(BuildContext context) {
    final cabinManager = Provider.of<CabinManager>(context, listen: false);
    final dayHandler = Provider.of<DayHandler>(context, listen: false);

    return ListView(
      itemExtent: itemExtent,
      children: [
        if (suggestedBooking != null)
          JumpBarItem(
            icon: Icons.auto_awesome,
            selected: true,
            onTap: () async {
              Navigator.of(context).pop();

              return showNewBookingDialog(
                context: context,
                booking: suggestedBooking!.copyWith(
                  cabin: suggestedBooking!.cabin ?? cabinManager.cabins.first,
                ),
                cabinManager: cabinManager,
              );
            },
            child: BookingSearchResult(booking: suggestedBooking!),
          ),
        if (searchedBookings != null)
          for (final booking in searchedBookings!)
            JumpBarItem(
              icon: Icons.event,
              onTap: () {
                dayHandler.dateTime = booking.startDate!;
                Navigator.of(context).pop();
                HomePage.of(homePageContext)
                    ?.setNavigationPage(AppPage.bookings);
              },
              child: BookingSearchResult(booking: booking),
            ),
      ],
    );
  }
}
