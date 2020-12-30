import 'package:cabin_booking/model/cabin_manager.dart';
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
  Future<int> _cabinsFuture;

  void _writeAndShowSnackBar() async {
    await _cabinManager.writeCabinsToFile();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(AppLocalizations.of(context).changesSaved),
        duration: const Duration(seconds: 1),
      ),
    );
  }

  @override
  void initState() {
    super.initState();

    _cabinManager = Provider.of<CabinManager>(context, listen: false);

    _cabinManager.addListener(_writeAndShowSnackBar);

    _cabinsFuture = _cabinManager.loadCabinsFromFile();
  }

  @override
  void dispose() {
    _cabinManager.removeListener(_writeAndShowSnackBar);

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<int>(
      future: _cabinsFuture,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(
            child: Text(
              AppLocalizations.of(context).dataCouldNotBeLoaded,
              style: Theme.of(context).textTheme.headline4,
            ),
          );
        } else if (snapshot.hasData) {
          return widget.pages[widget.railIndex];
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}
