import 'package:cabin_booking/constants.dart';
import 'package:cabin_booking/model.dart';
import 'package:cabin_booking/widgets/booking/bookings_table.dart';
import 'package:cabin_booking/widgets/cabin/cabin_icon.dart';
import 'package:cabin_booking/widgets/layout/time_column.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:horizontal_data_table/horizontal_data_table.dart';
import 'package:provider/provider.dart';

class ScrollableTimeTable extends StatelessWidget {
  const ScrollableTimeTable({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Expanded(
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: LayoutBuilder(
          builder: (context, constraints) {
            return Container(
              color: theme.dialogBackgroundColor,
              child: Consumer2<DayHandler, CabinManager>(
                builder: (context, dayHandler, cabinManager, child) {
                  final maxParentWidth = constraints.maxWidth;
                  final calculatedBookingStackWidth =
                      (maxParentWidth - kTimeColumnWidth) /
                          cabinManager.cabins.length;
                  final bookingStackWidth =
                      (calculatedBookingStackWidth < kBookingColumnMinWidth)
                          ? kBookingColumnMinWidth
                          : calculatedBookingStackWidth;

                  if (cabinManager.cabins.isEmpty) {
                    return Center(
                      child: Text(
                        AppLocalizations.of(context)!.noCabins,
                        textAlign: TextAlign.center,
                        style: theme.textTheme.headline5!
                            .copyWith(color: Colors.grey[600]),
                      ),
                    );
                  }

                  return HorizontalDataTable(
                    leftHandSideColumnWidth: kTimeColumnWidth,
                    rightHandSideColumnWidth:
                        bookingStackWidth * cabinManager.cabins.length,
                    isFixedHeader: true,
                    headerWidgets: [
                      Container(height: kBookingHeaderHeight),
                      Container(
                        color: theme.dialogBackgroundColor,
                        height: kBookingHeaderHeight,
                        padding: const EdgeInsets.symmetric(vertical: 24.0),
                        child: Row(
                          children: [
                            for (final cabin in cabinManager.cabins)
                              SizedBox(
                                width: bookingStackWidth,
                                child: CabinIcon(
                                  number: cabin.number,
                                  progress: cabin.occupancyPercentOn(
                                    dayHandler.dateTime,
                                    startTime: kTimeTableStartTime,
                                    endTime: kTimeTableEndTime,
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ],
                    leftSideItemBuilder: (context, index) {
                      return const TimeColumn();
                    },
                    rightSideItemBuilder: (context, index) {
                      return const BookingsTable();
                    },
                    itemCount: 1,
                    rowSeparatorWidget: const Divider(
                      color: Colors.black54,
                      height: 1.0,
                      thickness: 0.0,
                    ),
                    leftHandSideColBackgroundColor: theme.dialogBackgroundColor,
                    rightHandSideColBackgroundColor:
                        theme.dialogBackgroundColor,
                    verticalScrollbarStyle: const ScrollbarStyle(
                      isAlwaysShown: true,
                      thickness: 4.0,
                      radius: Radius.circular(5.0),
                    ),
                    horizontalScrollbarStyle: const ScrollbarStyle(
                      isAlwaysShown: true,
                      thickness: 4.0,
                      radius: Radius.circular(5.0),
                    ),
                    refreshIndicator: const WaterDropHeader(),
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }
}
