import 'package:cabin_booking/constants.dart';
import 'package:cabin_booking/model/cabin.dart';
import 'package:cabin_booking/model/cabin_manager.dart';
import 'package:cabin_booking/model/day_handler.dart';
import 'package:cabin_booking/widgets/booking/bookings_table.dart';
import 'package:cabin_booking/widgets/cabin/cabin_icon.dart';
import 'package:cabin_booking/widgets/layout/time_column.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:horizontal_data_table/horizontal_data_table.dart';
import 'package:provider/provider.dart';

class ScrollableTimeTable extends StatelessWidget {
  const ScrollableTimeTable();

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        width: MediaQuery.of(context).size.width,
        child: _getBodyWidget(context),
      ),
    );
  }

  Widget _getBodyWidget(context) {
    final theme = Theme.of(context);

    return LayoutBuilder(
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

              return Container(
                child: HorizontalDataTable(
                  leftHandSideColumnWidth: kTimeColumnWidth,
                  rightHandSideColumnWidth:
                      bookingStackWidth * cabinManager.cabins.length,
                  isFixedHeader: true,
                  headerWidgets: _getTitleWidget(
                      context, cabinManager.cabins, bookingStackWidth),
                  leftSideItemBuilder: _generateFirstColumnRow,
                  rightSideItemBuilder: _generateRightHandSideColumnRow,
                  itemCount: 1, // Hacking the widget a little bit
                  rowSeparatorWidget: const Divider(
                    color: Colors.black54,
                    height: 1.0,
                    thickness: 0.0,
                  ),
                  leftHandSideColBackgroundColor: theme.dialogBackgroundColor,
                  rightHandSideColBackgroundColor: theme.dialogBackgroundColor,
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
                  refreshIndicatorHeight: 60,
                ),
              );
            },
          ),
        );
      },
    );
  }

  List<Widget> _getTitleWidget(
    BuildContext context,
    Set<Cabin> cabins,
    double bookingStackWidth,
  ) {
    final theme = Theme.of(context);

    return [
      Container(height: kBookingHeaderHeight),
      Container(
        color: theme.dialogBackgroundColor,
        height: kBookingHeaderHeight,
        padding: const EdgeInsets.symmetric(vertical: 24.0),
        child: Row(
          children: [
            for (final cabin in cabins)
              _getTitleIconWidget(context, cabin, bookingStackWidth),
          ],
        ),
      ),
    ];
  }

  Widget _getTitleIconWidget(
    BuildContext context,
    Cabin cabin,
    double bookingStackWidth,
  ) {
    final dayHandler = Provider.of<DayHandler>(context);

    return SizedBox(
      width: bookingStackWidth,
      child: CabinIcon(
        number: cabin.number,
        progress: cabin.occupancyPercentOn(
          dayHandler.dateTime,
          startTime: kTimeTableStartTime,
          endTime: kTimeTableEndTime,
        ),
      ),
    );
  }

  Widget _generateFirstColumnRow(BuildContext context, int index) {
    return const TimeColumn();
  }

  Widget _generateRightHandSideColumnRow(BuildContext context, int index) {
    return const BookingsTable();
  }
}
