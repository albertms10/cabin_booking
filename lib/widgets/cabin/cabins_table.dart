import 'package:cabin_booking/model/cabin_manager.dart';
import 'package:cabin_booking/widgets/cabin/cabin_icon.dart';
import 'package:cabin_booking/widgets/layout/data_table_toolbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

class CabinTableRow {
  final String id;
  final int number;
  final int bookingsCount;
  final int recurringBookingsCount;
  final double occupancyRate;
  final List<List<TimeOfDay>> mostOccupiedTimeRanges;
  bool selected;

  CabinTableRow({
    this.id,
    this.number,
    this.bookingsCount,
    this.recurringBookingsCount,
    this.occupancyRate,
    this.mostOccupiedTimeRanges,
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
      _onSortOccupancyRate,
    ][columnIndex](ascending);

    setState(() {
      _sortColumnIndex = columnIndex;
      _sortAscending = ascending;
    });
  }

  @override
  Widget build(BuildContext context) {
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
                      child: Text(AppLocalizations.of(context).cabin),
                    ),
                    onSort: onSortColumn,
                  ),
                  DataColumn(
                    label: Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Text(AppLocalizations.of(context).bookings),
                    ),
                    numeric: true,
                    onSort: onSortColumn,
                  ),
                  DataColumn(
                    label: Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child:
                          Text(AppLocalizations.of(context).recurringBookings),
                    ),
                    numeric: true,
                    onSort: onSortColumn,
                  ),
                  DataColumn(
                    label: Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Text(AppLocalizations.of(context).occupancyRate),
                    ),
                    numeric: true,
                    onSort: onSortColumn,
                  ),
                  DataColumn(
                    label: Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Text(
                        AppLocalizations.of(context).mostOccupiedTimeRange,
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
                            style: Theme.of(context).textTheme.headline5,
                          ),
                        ),
                        DataCell(
                          Text(
                            '${cabinRow.recurringBookingsCount}',
                            style: Theme.of(context).textTheme.headline5,
                          ),
                        ),
                        DataCell(
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                '${(cabinRow.occupancyRate * 100).round()}',
                                style: Theme.of(context).textTheme.headline5,
                              ),
                              const SizedBox(width: 2),
                              Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const SizedBox(height: 2),
                                  Text(
                                    '%',
                                    style:
                                        Theme.of(context).textTheme.subtitle2,
                                  )
                                ],
                              ),
                            ],
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
              tooltip: AppLocalizations.of(context).empty,
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
