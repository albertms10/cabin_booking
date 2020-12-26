import 'package:cabin_booking/model/cabin.dart';
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
  final Cabin cabin;
  final int bookingsCount;
  final int recurringBookingsCount;
  final Duration accumulatedDuration;
  final double occupancyRate;
  final Set<List<TimeOfDay>> mostOccupiedTimeRanges;
  bool selected;

  CabinTableRow({
    @required this.cabin,
    this.bookingsCount = 0,
    this.recurringBookingsCount = 0,
    this.accumulatedDuration = const Duration(),
    this.occupancyRate = 0.0,
    this.mostOccupiedTimeRanges = const {},
    this.selected = false,
  });
}

class CabinTableColumn {
  final String title;
  final bool numeric;
  final bool sortable;

  const CabinTableColumn(
    this.title, {
    this.numeric = true,
    this.sortable = true,
  });
}

class CabinsTable extends StatefulWidget {
  final List<CabinTableRow> cabinRows;

  const CabinsTable({@required this.cabinRows});

  @override
  _CabinsTableState createState() => _CabinsTableState();

  List<CabinTableRow> get _selectedRows =>
      cabinRows.where((cabinRow) => cabinRow.selected).toList();

  List<String> get _selectedIds =>
      _selectedRows.map((cabinRow) => cabinRow.cabin.id).toList();

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
      widget.cabinRows.sort((a, b) => a.cabin.number.compareTo(b.cabin.number));
    } else {
      widget.cabinRows.sort((a, b) => b.cabin.number.compareTo(a.cabin.number));
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

  void onSortColumn(int columnIndex, bool ascending) {
    <_OnSortFunction>[
      _onSortNumber,
      _onSortBookingsCount,
      _onSortRecurringBookingsCount,
      _onSortAccumulatedDuration,
    ][columnIndex](ascending);

    setState(() {
      _sortColumnIndex = columnIndex;
      _sortAscending = ascending;
    });
  }

  @override
  Widget build(BuildContext context) {
    final appLocalizations = AppLocalizations.of(context);

    if (widget.cabinRows.isEmpty) {
      return CenteredIconMessage(
        icon: Icons.sensor_door,
        message: appLocalizations.noCabinsMessage,
      );
    }

    final theme = Theme.of(context);

    final columns = [
      CabinTableColumn(appLocalizations.cabin, numeric: false),
      CabinTableColumn(appLocalizations.bookings),
      CabinTableColumn(appLocalizations.recurringBookings),
      CabinTableColumn(appLocalizations.accumulatedTime),
      CabinTableColumn(appLocalizations.mostOccupiedTimeRange, sortable: false),
    ];

    return Stack(
      children: [
        ListView(
          key: const PageStorageKey('CabinsListView'),
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 54.0),
              child: DataTable(
                dataRowHeight: 82.0,
                showCheckboxColumn: true,
                sortAscending: _sortAscending,
                sortColumnIndex: _sortColumnIndex,
                columns: [
                  for (final column in columns)
                    DataColumn(
                      label: Padding(
                        padding: EdgeInsets.only(
                          right: column.numeric ? 0.0 : 8.0,
                          left: column.numeric ? 8.0 : 0.0,
                        ),
                        child: Text(column.title),
                      ),
                      onSort: column.sortable ? onSortColumn : null,
                      tooltip: column.sortable
                          ? '${appLocalizations.sortBy} ${column.title}'
                          : null,
                      numeric: column.numeric,
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
                          CabinIcon(number: cabinRow.cabin.number),
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
                                child: TweenAnimationBuilder<double>(
                                  tween: Tween<double>(
                                    begin: 0.0,
                                    end: cabinRow.occupancyRate,
                                  ),
                                  duration: const Duration(milliseconds: 700),
                                  curve: Curves.easeOutCubic,
                                  builder: (context, value, child) {
                                    return LinearProgressIndicator(
                                      value: value,
                                      backgroundColor: Colors.blue[100],
                                      semanticsLabel: 'Occupancy rate',
                                      semanticsValue:
                                          '${(value * 100).round()} %',
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                        DataCell(
                          Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: WrappedChipList(
                              items: cabinRow.mostOccupiedTimeRanges.toList(),
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
            if (widget._selectedRows.length == 1)
              IconButton(
                onPressed: () async {
                  final cabinManager =
                      Provider.of<CabinManager>(context, listen: false);

                  final selectedCabin = widget._selectedRows.first;

                  final editedCabin = await showDialog<Cabin>(
                    context: context,
                    builder: (context) => CabinDialog(
                      cabin: selectedCabin.cabin,
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
