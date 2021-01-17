import 'package:cabin_booking/model/date_range.dart';
import 'package:cabin_booking/model/item.dart';
import 'package:cabin_booking/utils/date.dart';
import 'package:cabin_booking/widgets/item/activity_line_chart.dart';
import 'package:cabin_booking/widgets/layout/centered_icon_message.dart';
import 'package:cabin_booking/widgets/layout/data_table_toolbar.dart';
import 'package:cabin_booking/widgets/layout/danger_alert_dialog.dart';
import 'package:cabin_booking/widgets/layout/detailed_figure.dart';
import 'package:cabin_booking/widgets/layout/duration_figure_unit.dart';
import 'package:cabin_booking/widgets/layout/wrapped_chip_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

typedef _OnSortFunction = void Function(bool);

class ItemsTable<T extends Item> extends StatefulWidget {
  final String Function(ItemsTableRow<T>) itemTitle;
  final IconData itemIcon;
  final String itemHeaderLabel;
  final List<ItemsTableRow<T>> rows;
  final String emptyMessage;

  final bool shallEdit;
  final bool shallEmpty;
  final bool shallRemove;

  final void Function(List<ItemsTableRow<T>>) onEditPressed;

  final String onEmptyTitle;
  final void Function(List<String>) onEmptyPressed;

  final String onRemoveTitle;
  final void Function(List<String>) onRemovePressed;

  const ItemsTable({
    this.itemTitle,
    this.itemIcon,
    this.itemHeaderLabel = 'Item',
    @required this.rows,
    this.emptyMessage,
    this.shallEdit = true,
    this.shallEmpty = true,
    this.shallRemove = true,
    this.onEditPressed,
    this.onEmptyTitle,
    this.onEmptyPressed,
    this.onRemoveTitle,
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

  void _onSortAccumulatedDuration(bool ascending) {
    if (ascending) {
      widget.rows.sort(
        (a, b) => a.occupiedDuration.compareTo(b.occupiedDuration),
      );
    } else {
      widget.rows.sort(
        (a, b) => b.occupiedDuration.compareTo(a.occupiedDuration),
      );
    }
  }

  void onSortColumn(int columnIndex, bool ascending) {
    <_OnSortFunction>[
      _onSortItem,
      _onSortBookingsCount,
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
      ItemsTableColumn(appLocalizations.accumulatedTime),
      ItemsTableColumn(appLocalizations.mostOccupiedTimeRange, sortable: false),
      ItemsTableColumn(appLocalizations.activity, sortable: false),
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
                      label: Flexible(
                        child: Padding(
                          padding: EdgeInsets.only(
                            right: column.numeric ? 0.0 : 8.0,
                            left: column.numeric ? 8.0 : 0.0,
                          ),
                          child: Text(
                            column.title,
                            overflow: TextOverflow.fade,
                          ),
                        ),
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
                          DetailedFigure(
                            figure:
                                row.bookingsCount + row.recurringBookingsCount,
                            details: [
                              row.bookingsCount,
                              row.recurringBookingsCount,
                            ],
                            tooltipMessage:
                                '${appLocalizations.bookings} + ${appLocalizations.recurringBookings}',
                          ),
                        ),
                        DataCell(
                          DurationFigureUnit(row.occupiedDuration),
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
                        DataCell(
                          ActivityLineChart(
                            occupiedDurationPerWeek:
                                row.occupiedDurationPerWeek,
                            tooltipMessage: row.item is DateRange
                                ? null
                                : appLocalizations.pastYearOfActivity,
                            dateRange: row.item is DateRange
                                ? row.item
                                : DateRange(
                                    startDate: firstWeekDate(DateTime.now()
                                        .subtract(const Duration(days: 365))),
                                    endDate: firstWeekDate(DateTime.now()),
                                  ),
                          ),
                        )
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
            if (widget.shallEdit && widget._selectedRows.length == 1)
              IconButton(
                onPressed: () => widget.onEditPressed(widget._selectedRows),
                icon: const Icon(Icons.edit),
                tooltip: appLocalizations.edit,
              ),
            if (widget.shallEmpty)
              IconButton(
                onPressed:
                    widget.onEmptyPressed == null || !widget.selectedAreBooked
                        ? null
                        : () async {
                            final shallDelete = await showDialog<bool>(
                              context: context,
                              builder: (context) => DangerAlertDialog(
                                title: widget.onEmptyTitle ??
                                    appLocalizations.emptyItemTitle,
                                content: appLocalizations.actionUndone,
                                okText: appLocalizations.empty,
                              ),
                            );

                            if (shallDelete == null || !shallDelete) return;

                            widget.onEmptyPressed(widget._selectedIds);
                          },
                icon: const Icon(Icons.delete_outline),
                tooltip: appLocalizations.empty,
              ),
            if (widget.shallRemove)
              IconButton(
                onPressed: widget.onRemovePressed == null
                    ? null
                    : () async {
                        final shallDelete = await showDialog<bool>(
                          context: context,
                          builder: (context) => DangerAlertDialog(
                            title: widget.onRemoveTitle ??
                                appLocalizations.deleteItemTitle,
                            content: appLocalizations.actionUndone,
                          ),
                        );

                        if (shallDelete == null || !shallDelete) return;

                        widget.onRemovePressed(widget._selectedIds);
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

class ItemsTableRow<T extends Item> {
  final T item;
  final int bookingsCount;
  final int recurringBookingsCount;
  final Duration occupiedDuration;
  final Map<DateTime, Duration> occupiedDurationPerWeek;
  final Set<List<TimeOfDay>> mostOccupiedTimeRanges;
  bool selected;

  ItemsTableRow({
    @required this.item,
    this.bookingsCount = 0,
    this.recurringBookingsCount = 0,
    this.occupiedDuration = const Duration(),
    this.occupiedDurationPerWeek = const {},
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
