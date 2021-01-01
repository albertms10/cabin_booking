import 'package:cabin_booking/model/cabin_manager.dart';
import 'package:cabin_booking/model/day_handler.dart';
import 'package:cabin_booking/model/school_year_manager.dart';
import 'package:cabin_booking/model/writable_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

class MainContent extends StatefulWidget {
  final int railIndex;
  final List<Widget> pages;

  const MainContent({this.railIndex, this.pages});

  @override
  _MainContentState createState() => _MainContentState();
}

class _MainContentState extends State<MainContent> {
  CabinManager _cabinManager;
  SchoolYearManager _schoolYearManager;

  void _writeAndShowSnackBar(WritableManager manager) async {
    await manager.writeToFile();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Expanded(
              child: Text(AppLocalizations.of(context).changesSaved),
            ),
            Chip(label: Text('${manager.runtimeType}')),
          ],
        ),
        duration: const Duration(seconds: 1),
      ),
    );
  }

  void _writeCabinsAndShowSnackBar() => _writeAndShowSnackBar(_cabinManager);

  void _writeSchoolYearsAndShowSnackBar() =>
      _writeAndShowSnackBar(_schoolYearManager);

  @override
  void initState() {
    super.initState();

    _cabinManager = Provider.of<CabinManager>(context, listen: false)
      ..addListener(_writeCabinsAndShowSnackBar);

    _schoolYearManager = Provider.of<DayHandler>(context, listen: false)
        .schoolYearManager
      ..addListener(_writeSchoolYearsAndShowSnackBar);
  }

  @override
  void dispose() {
    _cabinManager.removeListener(_writeCabinsAndShowSnackBar);
    _schoolYearManager.removeListener(_writeSchoolYearsAndShowSnackBar);

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureProvider<List<int>>(
      create: (context) => Future.wait([
        _cabinManager.loadFromFile(),
        _schoolYearManager.loadFromFile(),
      ]),
      initialData: const [],
      child: Consumer<List<int>>(
        builder: (context, items, child) {
          if (items == null) {
            return Center(
              child: Text(
                AppLocalizations.of(context).dataCouldNotBeLoaded,
                style: Theme.of(context).textTheme.headline4,
              ),
            );
          } else if (items.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          return widget.pages[widget.railIndex];
        },
      ),
    );
  }
}

/*
return FutureProvider<List<int>>(
      create: (context) => Future.wait([
        _cabinManager.loadFromFile(),
        _schoolYearManager.loadFromFile(),
      ]),
      initialData: const Center(child: CircularProgressIndicator()),
      child: widget.pages[widget.railIndex],
      catchError: (context, error) {
        return Center(
          child: Text(
            AppLocalizations.of(context).dataCouldNotBeLoaded,
            style: Theme.of(context).textTheme.headline4,
          ),
        );
      },
    );
*/
