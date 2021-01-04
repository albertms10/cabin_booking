import 'package:cabin_booking/model/item.dart';
import 'package:cabin_booking/widgets/layout/centered_icon_message.dart';
import 'package:cabin_booking/widgets/layout/data_table_toolbar.dart';
import 'package:cabin_booking/widgets/layout/duration_figure_unit.dart';
import 'package:cabin_booking/widgets/layout/wrapped_chip_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ItemsTableRow<T extends Item> {
  final T item;
  final int bookingsCount;
  final int recurringBookingsCount;
  final Duration accumulatedDuration;
  final double occupancyPercent;
  final Set<List<TimeOfDay>> mostOccupiedTimeRanges;
  bool selected;

  ItemsTableRow({
    @required this.item,
    this.bookingsCount = 0,
    this.recurringBookingsCount = 0,
    this.accumulatedDuration = const Duration(),
    this.occupancyPercent = 0.0,
    this.mostOccupiedTimeRanges = const {},
    this.selected = false,
  });
}

class ItemsTableColumn {
  final String title;
  final bool numeric;
  final bool sortable;

  const ItemsTableColumn(
    this.title, {
    this.numeric = true,
    this.sortable = true,
  });
}

typedef _OnSortFunction = void Function(bool);

class ItemsTable<T extends Item> extends StatefulWidget {
  final String Function(ItemsTableRow<T>) itemTitle;
  final IconData itemIcon;
  final String itemHeaderLabel;
  final List<ItemsTableRow<T>> rows;
  final String emptyMessage;

  final void Function(List<ItemsTableRow<T>>) onEditPressed;
  final void Function(List<String>) onEmptyPressed;
  final void Function(List<String>) onRemovePressed;

  const ItemsTable({
    this.itemTitle,
    this.itemIcon,
    this.itemHeaderLabel = 'Item',
    @required this.rows,
    this.emptyMessage,
    this.onEditPressed,
    this.onEmptyPressed,
    this.onRemovePressed,
  });

  @override
  _ItemsTableState createState() => _ItemsTableState();

  List<ItemsTableRow<T>> get _selectedRows =>
      rows.where((row) => row.selected).toList();

  List<String> get _selectedIds =>
      _selectedRows.map((row) => row.item.id).toList();

  bool get selectedAreBooked {
    for (final row in _selectedRows) {
      if (row.bookingsCount > 0 || row.recurringBookingsCount > 0) return true;
    }

    return false;
  }

  void unselect() {
    for (final row in rows) {
      if (row.selected) row.selected = false;
    }
  }
}

class _ItemsTableState<T extends Item> extends State<ItemsTable<T>> {
  bool _sortAscending = true;
  int _sortColumnIndex = 0;

  void _onSortItem(bool ascending) {
    if (ascending) {
      widget.rows.sort((a, b) => a.item.compareTo(b.item));
    } else {
      widget.rows.sort((a, b) => b.item.compareTo(a.item));
    }
  }

  void _onSortBookingsCount(bool ascending) {
    if (ascending) {
      widget.rows.sort((a, b) => a.bookingsCount.compareTo(b.bookingsCount));
    } else {
      widget.rows.sort((a, b) => b.bookingsCount.compareTo(a.bookingsCount));
    }
  }

  void _onSortRecurringBookingsCount(bool ascending) {
    if (ascending) {
      widget.rows.sort(
        (a, b) => a.recurringBookingsCount.compareTo(b.recurringBookingsCount),
      );
    } else {
      widget.rows.sort(
        (a, b) => b.recurringBookingsCount.compareTo(a.recurringBookingsCount),
      );
    }
  }

  void _onSortAccumulatedDuration(bool ascending) {
    if (ascending) {
      widget.rows.sort(
        (a, b) => a.accumulatedDuration.compareTo(b.accumulatedDuration),
      );
    } else {
      widget.rows.sort(
        (a, b) => b.accumulatedDuration.compareTo(a.accumulatedDuration),
      );
    }
  }

  void onSortColumn(int columnIndex, bool ascending) {
    <_OnSortFunction>[
      _onSortItem,
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

    if (widget.rows.isEmpty) {
      return CenteredIconMessage(
        icon: widget.itemIcon,
        message: widget.emptyMessage,
      );
    }

    final theme = Theme.of(context);

    final columns = [
      ItemsTableColumn(widget.itemHeaderLabel, numeric: false),
      ItemsTableColumn(appLocalizations.bookings),
      ItemsTableColumn(appLocalizations.recurringBookings),
      ItemsTableColumn(appLocalizations.accumulatedTime),
      ItemsTableColumn(appLocalizations.mostOccupiedTimeRange, sortable: false),
    ];

    return Stack(
      children: [
        ListView(
          key: PageStorageKey('${T}ListView'),
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
                  widget.rows.length,
                  (index) {
                    final row = widget.rows[index];

                    return DataRow(
                      selected: widget.rows[index].selected,
                      onSelectChanged: (selected) {
                        setState(
                          () => widget.rows[index].selected = selected,
                        );
                      },
                      cells: [
                        DataCell(
                          Row(
                            children: [
                              Icon(
                                widget.itemIcon,
                                color: Theme.of(context).accentColor,
                              ),
                              const SizedBox(width: 12.0),
                              Text(
                                widget.itemTitle?.call(row) ?? '',
                                style: theme.textTheme.headline5,
                              ),
                            ],
                          ),
                        ),
                        DataCell(
                          Text(
                            '${row.bookingsCount}',
                            style: theme.textTheme.headline5,
                          ),
                        ),
                        DataCell(
                          Text(
                            '${row.recurringBookingsCount}',
                            style: theme.textTheme.headline5,
                          ),
                        ),
                        DataCell(
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              DurationFigureUnit(row.accumulatedDuration),
                              const SizedBox(height: 12.0),
                              Padding(
                                padding: const EdgeInsets.only(left: 24.0),
                                child: TweenAnimationBuilder<double>(
                                  tween: Tween<double>(
                                    begin: 0.0,
                                    end: row.occupancyPercent,
                                  ),
                                  duration: const Duration(milliseconds: 700),
                                  curve: Curves.easeOutCubic,
                                  builder: (context, value, child) {
                                    return LinearProgressIndicator(
                                      value: value,
                                      backgroundColor:
                                          theme.accentColor.withOpacity(0.25),
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
                              items: row.mostOccupiedTimeRanges.toList(),
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
                onPressed: () => widget.onEditPressed(widget._selectedRows),
                icon: const Icon(Icons.edit),
                tooltip: appLocalizations.edit,
              ),
            IconButton(
              onPressed:
                  widget.onEmptyPressed != null && widget.selectedAreBooked
                      ? () => widget.onEmptyPressed(widget._selectedIds)
                      : null,
              icon: const Icon(Icons.delete_outline),
              tooltip: appLocalizations.empty,
            ),
            IconButton(
              onPressed: widget.onRemovePressed != null
                  ? () => widget.onRemovePressed(widget._selectedIds)
                  : null,
              icon: const Icon(Icons.delete),
              tooltip: MaterialLocalizations.of(context).deleteButtonTooltip,
            ),
          ],
        ),
      ],
    );
  }
}
