import 'package:cabin_booking/constants.dart';
import 'package:cabin_booking/model.dart';
import 'package:cabin_booking/utils/dialog.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:timer_builder/timer_builder.dart';

class EmptyBookingSlot extends StatelessWidget {
  final Cabin cabin;
  final DateTime startDateTime;
  final DateTime endDateTime;

  const EmptyBookingSlot({
    super.key,
    required this.cabin,
    required this.startDateTime,
    required this.endDateTime,
  });

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
                      : _EmptyBookingSlotActionable(
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

class _EmptyBookingSlotActionable extends StatelessWidget {
  final Cabin cabin;
  final DateTime startDateTime;
  final DateTime endDateTime;
  final int? preciseDuration;

  const _EmptyBookingSlotActionable({
    super.key,
    required this.cabin,
    required this.startDateTime,
    required this.endDateTime,
    this.preciseDuration,
  });

  @override
  Widget build(BuildContext context) {
    final cabinManager = Provider.of<CabinManager>(context, listen: false);

    final duration =
        preciseDuration ?? endDateTime.difference(startDateTime).inMinutes;

    return Container(
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(4)),
      ),
      margin: const EdgeInsets.all(8),
      child: Tooltip(
        message: '$duration min',
        child: InkWell(
          onTap: () {
            showNewBookingDialog(
              context: context,
              booking: SingleBooking(
                startDateTime: startDateTime,
                endDateTime: endDateTime,
                cabinId: cabin.id,
              ),
              cabinManager: cabinManager,
            );
          },
          borderRadius: const BorderRadius.all(Radius.circular(4)),
          child: Icon(Icons.add, size: 18, color: Theme.of(context).hintColor),
        ),
      ),
    );
  }
}
