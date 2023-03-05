import 'package:cabin_booking/constants.dart';
import 'package:cabin_booking/model.dart';
import 'package:cabin_booking/utils/date_time_extension.dart';
import 'package:cabin_booking/widgets/booking/booking_preview_panel_overlay.dart';
import 'package:cabin_booking/widgets/booking/bookings_table.dart';
import 'package:cabin_booking/widgets/cabin/cabin_icon.dart';
import 'package:cabin_booking/widgets/layout/centered_icon_message.dart';
import 'package:cabin_booking/widgets/layout/time_column.dart';
import 'package:cabin_booking/widgets/pages/home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:horizontal_data_table/horizontal_data_table.dart';
import 'package:provider/provider.dart';

class ScrollableTimeTable extends StatelessWidget {
  const ScrollableTimeTable({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Expanded(
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: ColoredBox(
          color: theme.dialogBackgroundColor,
          child: Consumer2<DayHandler, CabinCollection>(
            builder: (context, dayHandler, cabinCollection, child) {
              if (cabinCollection.cabins.isEmpty) {
                return Material(
                  child: InkWell(
                    onTap: () {
                      HomePage.of(context)?.setNavigationPage(AppPage.cabins);
                    },
                    child: CenteredIconMessage(
                      icon: Icons.sensor_door,
                      message: AppLocalizations.of(context)!.noCabinsMessage,
                    ),
                  ),
                );
              }

              return _ScrollablePanelOverlayTimeTable(
                cabins: cabinCollection.cabins,
                dateTime: dayHandler.dateTime,
              );
            },
          ),
        ),
      ),
    );
  }
}

typedef SetPreventTimeTableScroll = void Function({required bool value});

class _ScrollablePanelOverlayTimeTable extends StatefulWidget {
  final Set<Cabin> cabins;
  final DateTime dateTime;

  const _ScrollablePanelOverlayTimeTable({
    required this.cabins,
    required this.dateTime,
    super.key,
  });

  @override
  _ScrollablePanelOverlayTimeTableState createState() =>
      _ScrollablePanelOverlayTimeTableState();
}

class _ScrollablePanelOverlayTimeTableState
    extends State<_ScrollablePanelOverlayTimeTable> {
  bool _preventTimeTableScroll = false;

  void setPreventTimeTableScroll({required bool value}) {
    setState(() {
      _preventTimeTableScroll = value;
    });
  }

  double _stackWidth(double maxParentWidth) {
    final calculatedBookingStackWidth =
        (maxParentWidth - kTimeColumnWidth) / widget.cabins.length;

    return (calculatedBookingStackWidth < kBookingColumnMinWidth)
        ? kBookingColumnMinWidth
        : calculatedBookingStackWidth;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final dateRange = DateRange(
      startDate: widget.dateTime.addLocalTimeOfDay(kTimeTableStartTime),
      endDate: widget.dateTime.addLocalTimeOfDay(kTimeTableEndTime),
    );

    return LayoutBuilder(
      builder: (context, constraints) {
        final bookingStackWidth = _stackWidth(constraints.maxWidth);

        return BookingPreviewPanelOverlay(
          builder: (context, showPreviewPanel) {
            return HorizontalDataTable(
              leftHandSideColumnWidth: kTimeColumnWidth,
              rightHandSideColumnWidth:
                  bookingStackWidth * widget.cabins.length,
              isFixedHeader: true,
              headerWidgets: [
                const SizedBox(height: kBookingHeaderHeight),
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 24),
                  color: theme.dialogBackgroundColor,
                  height: kBookingHeaderHeight,
                  child: Row(
                    children: [
                      for (final cabin in widget.cabins)
                        SizedBox(
                          width: bookingStackWidth,
                          child: CabinIcon.progress(
                            number: cabin.number,
                            progress: cabin.bookingCollection
                                .occupancyPercentOn(dateRange),
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
                return BookingsTable(
                  cabins: widget.cabins,
                  dateTime: widget.dateTime,
                  showPreviewPanel: showPreviewPanel,
                  stackWidth: bookingStackWidth,
                  setPreventTimeTableScroll: setPreventTimeTableScroll,
                );
              },
              itemCount: 1,
              elevation: 2.5,
              leftHandSideColBackgroundColor: theme.dialogBackgroundColor,
              rightHandSideColBackgroundColor: theme.dialogBackgroundColor,
              verticalScrollbarStyle: const ScrollbarStyle(
                isAlwaysShown: true,
                thickness: 4,
                radius: Radius.circular(5),
              ),
              horizontalScrollbarStyle: const ScrollbarStyle(
                isAlwaysShown: true,
                thickness: 4,
                radius: Radius.circular(5),
              ),
              refreshIndicator: const WaterDropHeader(),
              scrollPhysics: _preventTimeTableScroll
                  ? const NeverScrollableScrollPhysics()
                  : null,
              horizontalScrollPhysics: _preventTimeTableScroll
                  ? const NeverScrollableScrollPhysics()
                  : null,
            );
          },
        );
      },
    );
  }
}
