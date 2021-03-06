import 'package:cabin_booking/model/cabin_manager.dart';
import 'package:cabin_booking/model/day_handler.dart';
import 'package:cabin_booking/model/school_year_manager.dart';
import 'package:cabin_booking/model/writable_manager.dart';
import 'package:cabin_booking/widgets/layout/save_changes_snack_bar_body.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

class MainContent extends StatefulWidget {
  final int railIndex;
  final List<Widget> pages;

  const MainContent({Key? key, required this.railIndex, this.pages = const []})
      : super(key: key);

  @override
  _MainContentState createState() => _MainContentState();
}

class _MainContentState extends State<MainContent> {
  late final CabinManager _cabinManager =
      Provider.of<CabinManager>(context, listen: false)
        ..addListener(_writeCabinsAndShowSnackBar);

  late final SchoolYearManager _schoolYearManager =
      Provider.of<DayHandler>(context, listen: false).schoolYearManager
        ..addListener(_writeSchoolYearsAndShowSnackBar);

  void _writeAndShowSnackBar(WritableManager manager) async {
    final changesSaved = await manager.writeToFile();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        behavior: SnackBarBehavior.floating,
        duration: Duration(milliseconds: changesSaved ? 1200 : 3000),
        content: SaveChangesSnackBarBody(changesSaved: changesSaved),
      ),
    );
  }

  void _writeCabinsAndShowSnackBar() => _writeAndShowSnackBar(_cabinManager);

  void _writeSchoolYearsAndShowSnackBar() =>
      _writeAndShowSnackBar(_schoolYearManager);

  @override
  void dispose() {
    _cabinManager.removeListener(_writeCabinsAndShowSnackBar);
    _schoolYearManager.removeListener(_writeSchoolYearsAndShowSnackBar);

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureProvider<List<int>?>(
      create: (context) => Future.wait([
        _cabinManager.loadFromFile(),
        _schoolYearManager.loadFromFile(),
      ]),
      initialData: const [],
      builder: (context, child) {
        final items = Provider.of<List<int>?>(context);
        if (items == null) {
          return Center(
            child: Text(
              AppLocalizations.of(context)!.dataCouldNotBeLoaded,
              style: Theme.of(context).textTheme.headline4,
            ),
          );
        } else if (items.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        return widget.pages[widget.railIndex];
      },
      catchError: (context, error) => null,
    );
  }
}
