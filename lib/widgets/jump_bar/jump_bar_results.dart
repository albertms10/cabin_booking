import 'package:cabin_booking/model.dart';
import 'package:cabin_booking/utils/dialog.dart';
import 'package:cabin_booking/widgets/jump_bar/booking_search_result.dart';
import 'package:cabin_booking/widgets/jump_bar/jump_bar_item.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class JumpBarResults extends StatelessWidget {
  final SingleBooking? suggestedBooking;
  final List<Booking>? searchedBookings;
  final double itemExtent;

  const JumpBarResults({
    super.key,
    this.suggestedBooking,
    this.searchedBookings,
    required this.itemExtent,
  });

  @override
  Widget build(BuildContext context) {
    return ListView(
      itemExtent: itemExtent,
      children: [
        if (suggestedBooking != null)
          JumpBarItem(
            icon: Icons.auto_awesome,
            selected: true,
            child: BookingSearchResult(booking: suggestedBooking!),
            onTap: () async {
              final cabinManager =
                  Provider.of<CabinManager>(context, listen: false);

              Navigator.of(context).pop();

              return showNewBookingDialog(
                context: context,
                booking: suggestedBooking!.copyWith(
                  cabinId:
                      suggestedBooking!.cabinId ?? cabinManager.cabins.first.id,
                ),
                cabinManager: cabinManager,
              );
            },
          ),
        if (searchedBookings != null)
          for (final booking in searchedBookings!)
            JumpBarItem(
              icon: Icons.event,
              child: BookingSearchResult(booking: booking),
              onTap: () {},
            ),
      ],
    );
  }
}
