import 'package:cabin_booking/widgets/booking/booking_floating_action_button.dart';
import 'package:cabin_booking/widgets/cabin/cabin_floating_action_button.dart';
import 'package:cabin_booking/widgets/pages/bookings_page.dart';
import 'package:cabin_booking/widgets/pages/cabins_page.dart';
import 'package:cabin_booking/widgets/pages/main_content.dart';
import 'package:cabin_booking/widgets/pages/school_years_page.dart';
import 'package:cabin_booking/widgets/pages/summary_page.dart';
import 'package:cabin_booking/widgets/school_year/school_year_floating_action_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class HomePage extends StatefulWidget {
  const HomePage();

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  final _floatingActionButtons = const [
    SizedBox(),
    BookingFloatingActionButton(),
    CabinFloatingActionButton(),
    SchoolYearFloatingActionButton(),
  ];

  void _setRailIndex(int index) {
    setState(() => _selectedIndex = index);
  }

  void _setRailPage(AppPages page) => _setRailIndex(page.index);

  @override
  Widget build(BuildContext context) {
    final appLocalizations = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          appLocalizations.title,
          style: TextStyle(
            color: Theme.of(context).colorScheme.onPrimary,
          ),
        ),
      ),
      floatingActionButton: _floatingActionButtons[_selectedIndex],
      body: SafeArea(
        child: Row(
          children: [
            NavigationRail(
              selectedIndex: _selectedIndex,
              onDestinationSelected: _setRailIndex,
              labelType: NavigationRailLabelType.selected,
              destinations: [
                NavigationRailDestination(
                  icon: const Icon(Icons.home_outlined),
                  selectedIcon: const Icon(Icons.home),
                  label: Text(appLocalizations.summary),
                ),
                NavigationRailDestination(
                  icon: const Icon(Icons.event_outlined),
                  selectedIcon: const Icon(Icons.event),
                  label: Text(appLocalizations.bookings),
                ),
                NavigationRailDestination(
                  icon: const Icon(Icons.sensor_door_outlined),
                  selectedIcon: const Icon(Icons.sensor_door),
                  label: Text(appLocalizations.cabins),
                ),
                NavigationRailDestination(
                  icon: const Icon(Icons.school_outlined),
                  selectedIcon: const Icon(Icons.school),
                  label: Text(appLocalizations.schoolYears),
                ),
              ],
            ),
            const VerticalDivider(thickness: 1.0, width: 1.0),
            Expanded(
              child: MainContent(
                railIndex: _selectedIndex,
                pages: [
                  SummaryPage(setRailPage: _setRailPage),
                  const BookingsPage(),
                  const CabinsPage(),
                  const SchoolYearsPage(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

enum AppPages { Summary, Bookings, Cabins, SchoolYears }

