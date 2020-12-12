import 'package:cabin_booking/model/cabin.dart';
import 'package:cabin_booking/model/cabin_components.dart';
import 'package:cabin_booking/model/cabin_manager.dart';
import 'package:cabin_booking/widgets/cabin/cabin_dialog.dart';
import 'package:cabin_booking/widgets/cabin/cabin_icon.dart';
import 'package:cabin_booking/widgets/layout/centered_icon_message.dart';
import 'package:cabin_booking/widgets/layout/data_table_toolbar.dart';
import 'package:cabin_booking/widgets/layout/duration_figure_unit.dart';
import 'package:cabin_booking/widgets/layout/wrapped_chip_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

class CabinTableRow {
  final String id;
  final int number;
  final CabinComponents components;
  final int bookingsCount;
  final int recurringBookingsCount;
  final Duration accumulatedDuration;
  final double occupancyRate;
  final List<List<TimeOfDay>> mostOccupiedTimeRanges;
  bool selected;

  CabinTableRow({
    @required this.id,
    @required this.number,
    @required this.components,
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

  const CabinsTable({@required this.cabinRows});

  @override
  _CabinsTableState createState() => _CabinsTableState();

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

typedef _OnSortFunction = void Function(bool ascending);

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
              padding: const EdgeInsets.only(top: 54.0),
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
                      child: Text(appLocalizations.accumulatedTime),
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
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              DurationFigureUnit(cabinRow.accumulatedDuration),
                              const SizedBox(height: 8.0),
                              Padding(
                                padding: const EdgeInsets.only(left: 24.0),
                                child: LinearProgressIndicator(
                                  value: cabinRow.occupancyRate,
                                  backgroundColor: Colors.blue[100],
                                  semanticsLabel: 'Occupancy rate',
                                  semanticsValue:
                                      '${(cabinRow.occupancyRate * 100).round()} %',
                                ),
                              ),
                            ],
                          ),
                        ),
                        DataCell(
                          Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: WrappedChipList(
                              items: cabinRow.mostOccupiedTimeRanges,
                              maxChips: 1,
                              labelBuilder:
                                  (context, List<TimeOfDay> timeRange) {
                                return Text(
                                  '${timeRange.first.format(context)}–${timeRange.last.format(context)}',
                                );
                              },
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
          shown: widget._selectedRows.isNotEmpty,
          selectedItems: widget._selectedRows.length,
          onPressedLeading: () {
            setState(() => widget.unselect());
          },
          actions: [
            IconButton(
              onPressed: widget._selectedRows.length > 1
                  ? null
                  : () async {
                      final cabinManager =
                          Provider.of<CabinManager>(context, listen: false);

                      final selectedCabin = widget._selectedRows.first;

                      final editedCabin = await showDialog<Cabin>(
                        context: context,
                        builder: (context) => CabinDialog(
                          cabin: Cabin(
                            id: selectedCabin.id,
                            number: selectedCabin.number,
                            components: selectedCabin.components,
                          ),
                        ),
                      );

                      if (editedCabin != null) {
                        cabinManager.modifyCabin(editedCabin);
                      }
                    },
              icon: const Icon(Icons.edit),
              tooltip: appLocalizations.edit,
            ),
            IconButton(
              onPressed: widget.selectedAreBooked
                  ? () => widget.emptySelected(context)
                  : null,
              icon: const Icon(Icons.delete_outline),
              tooltip: appLocalizations.empty,
            ),
            IconButton(
              onPressed: () => widget.removeSelected(context),
              icon: const Icon(Icons.delete),
              tooltip: MaterialLocalizations.of(context).deleteButtonTooltip,
            ),
          ],
        ),
      ],
    );
  }
}
