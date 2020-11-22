import 'package:cabin_booking/l10n/app_localizations.dart';
import 'package:cabin_booking/model/cabin_manager.dart';
import 'package:cabin_booking/widgets/pages/bookings_page.dart';
import 'package:cabin_booking/widgets/pages/cabins_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MainContent extends StatefulWidget {
  final int railIndex;

  MainContent({Key key, this.railIndex}) : super(key: key);

  final pages = [
    CabinsPage(),
    BookingsPage(),
  ];

  @override
  _MainContentState createState() => _MainContentState();
}

class _MainContentState extends State<MainContent> {
  CabinManager _cabinManager;
  Future _future;

  @override
  void initState() {
    super.initState();

    _cabinManager = Provider.of<CabinManager>(context, listen: false);

    _cabinManager.addListener(() async {
      await _cabinManager.writeCabinsToFile();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context).changesSaved),
        ),
      );
    });

    _future = _cabinManager.loadCabinsFromFile();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _future,
      builder: (context, snapshot) {
        if (snapshot.hasError)
          return Center(
            child: Text(
              AppLocalizations.of(context).dataCouldNotBeLoaded,
              style: Theme.of(context).textTheme.headline4,
            ),
          );
        else if (snapshot.hasData)
          return widget.pages[widget.railIndex];
        else
          return const Center(child: CircularProgressIndicator());
      },
    );
  }
}
