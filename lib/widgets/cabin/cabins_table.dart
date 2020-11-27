import 'package:cabin_booking/l10n/app_localizations.dart';
import 'package:cabin_booking/model/cabin_manager.dart';
import 'package:cabin_booking/widgets/cabin/cabin_icon.dart';
import 'package:cabin_booking/widgets/layout/data_table_toolbar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CabinTableRow {
  final String id;
  final int number;
  final int bookingsCount;
  final int recurringBookingsCount;
  final double occupancyRate;
  bool selected;

  CabinTableRow({
    this.id,
    this.number,
    this.bookingsCount,
    this.recurringBookingsCount,
    this.occupancyRate,
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

  void unselect() {
    for (final cabin in cabinRows) {
      if (cabin.selected) cabin.selected = false;
    }
  }

  void removeSelected(BuildContext context) {
    final removableIds = cabinRows
        .where((cabin) => cabin.selected)
        .map((cabin) => cabin.id)
        .toList();

    Provider.of<CabinManager>(context, listen: false)
        .removeCabinsByIds(removableIds);
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
              onPressed: () {
                widget.removeSelected(context);
              },
              icon: const Icon(Icons.delete),
            ),
          ],
        ),
      ],
    );
  }
}
