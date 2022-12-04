import 'package:cabin_booking/constants.dart';
import 'package:cabin_booking/model.dart';
import 'package:cabin_booking/utils/dialog.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:timer_builder/timer_builder.dart';

class EmptyBookingSlot extends StatelessWidget {
  final Cabin cabin;
  final DateTime startDate;
  final DateTime endDate;

  const EmptyBookingSlot({
    super.key,
    required this.cabin,
    required this.startDate,
    required this.endDate,
  });

  @override
  Widget build(BuildContext context) {
    return TimerBuilder.periodic(
      const Duration(seconds: 30),
      builder: (context) {
        final now = DateTime.now();

        final fullDuration = endDate.difference(startDate);

        final startToNowDuration = now.difference(startDate);
        final startsBeforeNow = now.compareTo(startDate) > 0;

        final endToNowDuration = endDate.difference(now);
        final endsAfterNow = endDate.compareTo(now) > 0;

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
                          endDate.compareTo(now) < 0
                      ? null
                      : _EmptyBookingSlotActionable(
                          cabin: cabin,
                          startDate: startsBeforeNow ? now : startDate,
                          endDate: endDate,
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
  final DateTime startDate;
  final DateTime endDate;
  final int? preciseDuration;

  const _EmptyBookingSlotActionable({
    super.key,
    required this.cabin,
    required this.startDate,
    required this.endDate,
    this.preciseDuration,
  });

  @override
  Widget build(BuildContext context) {
    final cabinManager = Provider.of<CabinManager>(context, listen: false);

    final duration = preciseDuration ?? endDate.difference(startDate).inMinutes;

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
                startDate: startDate,
                endDate: endDate,
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
