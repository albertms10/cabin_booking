import 'package:cabin_booking/constants.dart';
import 'package:cabin_booking/model/cabin_manager.dart';
import 'package:cabin_booking/model/day_handler.dart';
import 'package:cabin_booking/utils/map_number.dart';
import 'package:cabin_booking/widgets/booking/bookings_scroll_view.dart';
import 'package:cabin_booking/widgets/cabin/cabin_icon.dart';
import 'package:cabin_booking/widgets/standalone/carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BookingsPageView extends StatelessWidget {
  const BookingsPageView();

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Consumer2<DayHandler, CabinManager>(
          builder: (context, dayHandler, cabinManager, child) {
            return CarouselSlider(
              items: [
                for (final cabin in cabinManager.cabins)
                  Container(
                    margin: const EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: const BorderRadius.all(
                        Radius.circular(64.0),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey[200],
                          blurRadius: 4,
                          offset: const Offset(4.0, 4.0),
                        )
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: const BorderRadius.all(
                        Radius.circular(64.0),
                      ),
                      child: BookingsScrollView(
                        cabin: cabin.simplified(),
                        bookings: cabin.bookingsOn(dayHandler.dateTime),
                        cabinIcon: CabinIcon(
                          number: cabin.number,
                          progress: cabin.occupiedRatioOn(
                            dayHandler.dateTime,
                            startTime: timeTableStartTime,
                            endTime: timeTableEndTime,
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
              options: CarouselOptions(
                pageViewKey: const PageStorageKey('BookingsCarouselSlider'),
                enableInfiniteScroll: false,
                height: double.infinity,
                viewportFraction:
                    responsiveViewportFraction(constraints.maxWidth),
                scrollPhysics: const PageViewScrollPhysics(itemDimension: 1000),
              ),
            );
          },
        );
      },
    );
  }
}

double responsiveViewportFraction(double windowWidth) {
  if (windowWidth < 250) {
    return 1;
  } else {
    return 1 /
        mapNumber(
          windowWidth,
          inMin: 200,
          inMax: 2000,
          outMin: 1,
          outMax: 7,
        ).floor();
  }
}

class PageViewScrollPhysics extends ScrollPhysics {
  final double itemDimension;

  const PageViewScrollPhysics({this.itemDimension, ScrollPhysics parent})
      : super(parent: parent);

  @override
  PageViewScrollPhysics applyTo(ScrollPhysics ancestor) {
    return PageViewScrollPhysics(
      itemDimension: itemDimension,
      parent: buildParent(ancestor),
    );
  }

  double _getPage(ScrollMetrics position, double portion) =>
      (position.pixels + portion) / itemDimension;

  double _getPixels(double page, double portion) =>
      (page * itemDimension) - portion;

  double _getTargetPixels(
    ScrollPosition position,
    Tolerance tolerance,
    double velocity,
    double portion,
  ) {
    var page = _getPage(position, portion);

    if (velocity < -tolerance.velocity) {
      page -= 0.5;
    } else if (velocity > tolerance.velocity) {
      page += 0.5;
    }

    return _getPixels(page.roundToDouble(), portion);
  }

  @override
  Simulation createBallisticSimulation(
    ScrollMetrics position,
    double velocity,
  ) {
    // If we're out of range and not headed back in range, defer to the parent
    // ballistics, which should put us back in range at a page boundary.
    if ((velocity <= 0.0 && position.pixels <= position.minScrollExtent) ||
        (velocity >= 0.0 && position.pixels >= position.maxScrollExtent)) {
      return super.createBallisticSimulation(position, velocity);
    }

    final tolerance = this.tolerance;
    final portion = (position.extentInside - itemDimension) / 2;
    final target = _getTargetPixels(position, tolerance, velocity, portion);

    if (target != position.pixels) {
      return ScrollSpringSimulation(
        spring,
        position.pixels,
        target,
        velocity,
        tolerance: tolerance,
      );
    }

    return null;
  }

  @override
  bool get allowImplicitScrolling => false;
}
