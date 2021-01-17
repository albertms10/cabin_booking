import 'package:cabin_booking/constants.dart';
import 'package:cabin_booking/model/booking.dart';
import 'package:cabin_booking/model/cabin.dart';
import 'package:cabin_booking/model/cabin_manager.dart';
import 'package:cabin_booking/utils/date.dart';
import 'package:cabin_booking/utils/show_booking_dialog.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:timer_builder/timer_builder.dart';

class EmptyBookingSlot extends StatelessWidget {
  final Cabin cabin;
  final DateTime startDateTime;
  final DateTime endDateTime;

  const EmptyBookingSlot({
    Key key,
    @required this.cabin,
    @required this.startDateTime,
    @required this.endDateTime,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TimerBuilder.periodic(
      const Duration(seconds: 30),
      builder: (context) {
        final now = DateTime.now();

        final fullDuration = endDateTime.difference(startDateTime);

        final startToNowDuration = now.difference(startDateTime);
        final startsBeforeNow = now.compareTo(startDateTime) > 0;

        final endToNowDuration = endDateTime.difference(now);
        final endsAfterNow = endDateTime.compareTo(now) > 0;

        final duration =
            startsBeforeNow && endsAfterNow ? endToNowDuration : fullDuration;

        final preciseDuration =
            (duration.inMicroseconds / Duration.microsecondsPerMinute).ceil();

        return Column(
          children: [
            if (startsBeforeNow && endsAfterNow)
              SizedBox(
                height: startToNowDuration.inMinutes * kBookingHeightRatio,
              ),
            TweenAnimationBuilder<double>(
              tween: Tween<double>(
                begin: preciseDuration * kBookingHeightRatio,
                end: preciseDuration * kBookingHeightRatio,
              ),
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOutCubic,
              builder: (context, value, child) {
                return SizedBox(
                  width: double.infinity,
                  height: value,
                  child: duration.compareTo(kMinSlotDuration) < 0 ||
                          endDateTime.compareTo(now) < 0
                      ? null
                      : EmptyBookingSlotActionable(
                          cabin: cabin,
                          startDateTime: startsBeforeNow ? now : startDateTime,
                          endDateTime: endDateTime,
                          preciseDuration: preciseDuration,
                        ),
                );
              },
            ),
          ],
        );
      },
    );
  }
}

class EmptyBookingSlotActionable extends StatelessWidget {
  final Cabin cabin;
  final DateTime startDateTime;
  final DateTime endDateTime;
  final int preciseDuration;

  const EmptyBookingSlotActionable({
    this.cabin,
    this.startDateTime,
    this.endDateTime,
    this.preciseDuration,
  });

  @override
  Widget build(BuildContext context) {
    final cabinManager = Provider.of<CabinManager>(context, listen: false);

    return Container(
      margin: const EdgeInsets.all(8.0),
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(4.0)),
      ),
      child: Tooltip(
        message: '${preciseDuration} min',
        child: InkWell(
          borderRadius: const BorderRadius.all(Radius.circular(4.0)),
          onTap: () {
            showNewBookingDialog(
              context: context,
              booking: Booking(
                date: dateOnly(startDateTime),
                startTime: TimeOfDay.fromDateTime(startDateTime),
                endTime: TimeOfDay.fromDateTime(endDateTime),
                cabinId: cabin.id,
              ),
              cabinManager: cabinManager,
            );
          },
          child: Icon(
            Icons.add,
            size: 18.0,
            color: Theme.of(context).hintColor,
          ),
        ),
      ),
    );
  }
}
