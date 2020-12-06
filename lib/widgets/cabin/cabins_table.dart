import 'package:cabin_booking/model/cabin_manager.dart';
import 'package:cabin_booking/widgets/cabin/cabin_icon.dart';
import 'package:cabin_booking/widgets/layout/centered_icon_message.dart';
import 'package:cabin_booking/widgets/layout/data_table_toolbar.dart';
import 'package:cabin_booking/widgets/layout/figure_unit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

class CabinTableRow {
  final String id;
  final int number;
  final int bookingsCount;
  final int recurringBookingsCount;
  final Duration accumulatedDuration;
  final double occupancyRate;
  final List<List<TimeOfDay>> mostOccupiedTimeRanges;
  bool selected;

  CabinTableRow({
    @required this.id,
    @required this.number,
    this.bookingsCount = 0,
    this.recurringBookingsCount = 0,
    this.accumulatedDuration = const Duration(),
    this.occupancyRate = 0.0,
    this.mostOccupiedTimeRanges = const [],
    this.selected = false,
  });
}

class CabinsTable extends StatefulWidget {
  final List<CabinTableRow> cabinRows;

  CabinsTable({
    Key key,
    @required this.cabinRows,
  }) : super(key: key);

  @override
  _CabinsTableState createState() => _CabinsTableState();

  int get selectedItems {
    var count = 0;

    for (final cabin in cabinRows) {
      if (cabin.selected) count++;
    }

    return count;
  }

  List<CabinTableRow> get _selectedRows =>
      cabinRows.where((cabin) => cabin.selected).toList();

  List<String> get _selectedIds =>
      _selectedRows.map((cabin) => cabin.id).toList();

  bool get selectedAreBooked {
    for (final row in _selectedRows) {
      if (row.bookingsCount > 0 || row.recurringBookingsCount > 0) return true;
    }

    return false;
  }

  void unselect() {
    for (final cabin in cabinRows) {
      if (cabin.selected) cabin.selected = false;
    }
  }

  void emptySelected(BuildContext context) {
    Provider.of<CabinManager>(context, listen: false)
        .emptyCabinsByIds(_selectedIds);
  }

  void removeSelected(BuildContext context) {
    Provider.of<CabinManager>(context, listen: false)
        .removeCabinsByIds(_selectedIds);
  }
}

typedef _OnSortFunction = Function(bool ascending);

class _CabinsTableState extends State<CabinsTable> {
  bool _sortAscending = true;
  int _sortColumnIndex = 0;

  void _onSortNumber(bool ascending) {
    if (ascending) {
      widget.cabinRows.sort((a, b) => a.number.compareTo(b.number));
    } else {
      widget.cabinRows.sort((a, b) => b.number.compareTo(a.number));
    }
  }

  void _onSortBookingsCount(bool ascending) {
    if (ascending) {
      widget.cabinRows.sort(
        (a, b) => a.bookingsCount.compareTo(b.bookingsCount),
      );
    } else {
      widget.cabinRows.sort(
        (a, b) => b.bookingsCount.compareTo(a.bookingsCount),
      );
    }
  }

  void _onSortRecurringBookingsCount(bool ascending) {
    if (ascending) {
      widget.cabinRows.sort(
        (a, b) => a.recurringBookingsCount.compareTo(b.recurringBookingsCount),
      );
    } else {
      widget.cabinRows.sort(
        (a, b) => b.recurringBookingsCount.compareTo(a.recurringBookingsCount),
      );
    }
  }

  void _onSortAccumulatedDuration(bool ascending) {
    if (ascending) {
      widget.cabinRows.sort(
        (a, b) => a.accumulatedDuration.compareTo(b.accumulatedDuration),
      );
    } else {
      widget.cabinRows.sort(
        (a, b) => b.accumulatedDuration.compareTo(a.accumulatedDuration),
      );
    }
  }

  void _onSortOccupancyRate(bool ascending) {
    if (ascending) {
      widget.cabinRows.sort(
        (a, b) => a.occupancyRate.compareTo(b.occupancyRate),
      );
    } else {
      widget.cabinRows.sort(
        (a, b) => b.occupancyRate.compareTo(a.occupancyRate),
      );
    }
  }

  void onSortColumn(int columnIndex, bool ascending) {
    <_OnSortFunction>[
      _onSortNumber,
      _onSortBookingsCount,
      _onSortRecurringBookingsCount,
      _onSortAccumulatedDuration,
      _onSortOccupancyRate,
    ][columnIndex](ascending);

    setState(() {
      _sortColumnIndex = columnIndex;
      _sortAscending = ascending;
    });
  }

  @override
  Widget build(BuildContext context) {
    final appLocalizations = AppLocalizations.of(context);
    final theme = Theme.of(context);

    if (widget.cabinRows.isEmpty) {
      return CenteredIconMessage(
        icon: Icons.sensor_door,
        message: appLocalizations.noCabinsMessage,
      );
    }

    return Stack(
      children: [
        ListView(
          children: [
            Padding(
              padding: const EdgeInsets.all(54.0),
              child: DataTable(
                dataRowHeight: 82.0,
                showCheckboxColumn: true,
                sortAscending: _sortAscending,
                sortColumnIndex: _sortColumnIndex,
                columns: [
                  DataColumn(
                    label: Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: Text(appLocalizations.cabin),
                    ),
                    onSort: onSortColumn,
                  ),
                  DataColumn(
                    label: Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Text(appLocalizations.bookings),
                    ),
                    numeric: true,
                    onSort: onSortColumn,
                  ),
                  DataColumn(
                    label: Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Text(appLocalizations.recurringBookings),
                    ),
                    numeric: true,
                    onSort: onSortColumn,
                  ),
                  DataColumn(
                    label: Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Text(appLocalizations.hours),
                    ),
                    numeric: true,
                    onSort: onSortColumn,
                  ),
                  DataColumn(
                    label: Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Text(appLocalizations.occupancyRate),
                    ),
                    numeric: true,
                    onSort: onSortColumn,
                  ),
                  DataColumn(
                    label: Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Text(
                        appLocalizations.mostOccupiedTimeRange,
                      ),
                    ),
                  ),
                ],
                rows: List<DataRow>.generate(
                  widget.cabinRows.length,
                  (index) {
                    final cabinRow = widget.cabinRows[index];

                    return DataRow(
                      selected: widget.cabinRows[index].selected,
                      onSelectChanged: (selected) {
                        setState(
                          () => widget.cabinRows[index].selected = selected,
                        );
                      },
                      cells: [
                        DataCell(
                          CabinIcon(number: cabinRow.number),
                        ),
                        DataCell(
                          Text(
                            '${cabinRow.bookingsCount}',
                            style: theme.textTheme.headline5,
                          ),
                        ),
                        DataCell(
                          Text(
                            '${cabinRow.recurringBookingsCount}',
                            style: theme.textTheme.headline5,
                          ),
                        ),
                        DataCell(
                          Text(
                            '${cabinRow.accumulatedDuration.inHours}',
                            style: theme.textTheme.headline5,
                          ),
                        ),
                        DataCell(
                          FigureUnit(
                            value: (cabinRow.occupancyRate * 100).round(),
                            unit: '%',
                          ),
                        ),
                        DataCell(
                          Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: Wrap(
                              spacing: 8.0,
                              runSpacing: 6.0,
                              children: [
                                for (final timeRange
                                    in cabinRow.mostOccupiedTimeRanges)
                                  Chip(
                                    label: Text(
                                      '${timeRange.first.format(context)}–${timeRange.last.format(context)}',
                                    ),
                                  )
                              ],
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
          ],
        ),
        DataTableToolbar(
          shown: widget.selectedItems > 0,
          selectedItems: widget.selectedItems,
          onPressedLeading: () {
            setState(() {
              widget.unselect();
            });
          },
          actions: [
            IconButton(
              onPressed: widget.selectedAreBooked
                  ? () {
                      widget.emptySelected(context);
                    }
                  : null,
              icon: const Icon(Icons.delete_outline),
              tooltip: appLocalizations.empty,
            ),
            IconButton(
              onPressed: () {
                widget.removeSelected(context);
              },
              icon: const Icon(Icons.delete),
              tooltip: MaterialLocalizations.of(context).deleteButtonTooltip,
            ),
          ],
        ),
      ],
    );
  }
}
