import 'package:cabin_booking/constants.dart';
import 'package:cabin_booking/l10n/app_localizations.dart';
import 'package:cabin_booking/model/cabin_manager.dart';
import 'package:cabin_booking/widgets/cabin/cabin_icon.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CabinsTable extends StatefulWidget {
  CabinsTable({Key key}) : super(key: key);

  @override
  _CabinsTableState createState() => _CabinsTableState();
}

class _CabinsTableState extends State<CabinsTable> {
  CabinManager _cabinManager;

  List<bool> _selected;

  @override
  void initState() {
    super.initState();

    _cabinManager = Provider.of<CabinManager>(context, listen: false);

    _selected =
        List<bool>.generate(_cabinManager.cabins.length, (index) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<CabinManager>(
      builder: (context, cabinManager, child) {
        return DataTable(
          dataRowHeight: 82.0,
          showCheckboxColumn: true,
          columns: [
            DataColumn(
              label: Text(
                AppLocalizations.of(context).cabin,
                textAlign: TextAlign.center,
              ),
            ),
            DataColumn(
              numeric: true,
              label: Text(
                AppLocalizations.of(context).bookings,
                textAlign: TextAlign.center,
              ),
            ),
            DataColumn(
              numeric: true,
              label: Text(
                AppLocalizations.of(context).recurringBookings,
                textAlign: TextAlign.center,
              ),
            ),
            DataColumn(
              numeric: true,
              label: Text(
                AppLocalizations.of(context).occupancyRate,
                textAlign: TextAlign.center,
              ),
            ),
          ],
          rows: List<DataRow>.generate(
            _cabinManager.cabins.length,
            (index) {
              return DataRow(
                selected: _selected[index],
                onSelectChanged: (selected) {
                  setState(() => _selected[index] = selected);
                },
                cells: [
                  DataCell(
                    CabinIcon(number: _cabinManager.cabins[index].number),
                  ),
                  DataCell(
                    Text(
                      '${_cabinManager.cabins[index].bookings.length}',
                      style: Theme.of(context).textTheme.headline5,
                    ),
                  ),
                  DataCell(
                    Text(
                      '${_cabinManager.cabins[index].generatedRecurringBookings.length}',
                      style: Theme.of(context).textTheme.headline5,
                    ),
                  ),
                  DataCell(
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          '${(_cabinManager.cabins[index].evertimeOccupiedRatio(
                                startTime: timeTableStartTime,
                                endTime: timeTableEndTime,
                              ) * 100).round()}',
                          style: Theme.of(context).textTheme.headline5,
                        ),
                        const SizedBox(width: 2),
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const SizedBox(height: 2),
                            Text(
                              '%',
                              style: Theme.of(context).textTheme.subtitle2,
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
        );
      },
    );
  }
}
