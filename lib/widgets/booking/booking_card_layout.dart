import 'package:cabin_booking/app_styles.dart';
import 'package:cabin_booking/src/model/booking/booking.dart';
import 'package:flutter/material.dart';

class BookingCardLayout extends StatelessWidget {
  final Booking booking;
  final double? width;
  final double? height;
  final double elevation;
  final Widget? child;

  const BookingCardLayout({
    super.key,
    required this.booking,
    this.width,
    required this.height,
    this.elevation = 0,
    this.child,
  });

  static const double outerInset = 8;

  @override
  Widget build(BuildContext context) {
    final isBeforeNow = booking.endDate!.isBefore(DateTime.now());

    return Card(
      shadowColor: isBeforeNow ? Colors.black38 : Colors.black87,
      elevation: elevation,
      shape: RoundedRectangleBorder(
        side: BorderSide(
          color: Colors.grey[300]!.withOpacity(isBeforeNow ? 0.41 : 1),
          width: 1.5,
        ),
        borderRadius: borderRadiusLarge,
      ),
      margin: const EdgeInsets.all(outerInset),
      child: Container(
        decoration: booking.isLocked
            ? const BoxDecoration(
                borderRadius: borderRadiusLarge,
                gradient: LinearGradient(
                  begin: AlignmentDirectional.topStart,
                  end: Alignment(-0.4, -0.2),
                  colors: [
                    Color.fromARGB(16, 0, 0, 0),
                    Color.fromARGB(16, 0, 0, 0),
                    Colors.white10,
                    Colors.white10,
                  ],
                  stops: [0, 0.5, 0.5, 1],
                  tileMode: TileMode.repeated,
                ),
              )
            : BoxDecoration(
                color: Theme.of(context)
                    .cardColor
                    .withOpacity(isBeforeNow ? 0.41 : 1),
                borderRadius: borderRadiusLarge,
              ),
        width: width,
        height: height,
        child: child,
      ),
    );
  }
}
