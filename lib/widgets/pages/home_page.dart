import 'package:cabin_booking/widgets/booking/booking_floating_action_button.dart';
import 'package:cabin_booking/widgets/cabin/cabin_floating_action_button.dart';
import 'package:cabin_booking/widgets/pages/bookings_page.dart';
import 'package:cabin_booking/widgets/pages/cabins_page.dart';
import 'package:cabin_booking/widgets/pages/main_content.dart';
import 'package:cabin_booking/widgets/pages/summary_page.dart';
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
    CabinFloatingActionButton(),
    BookingFloatingActionButton(),
  ];

  @override
  Widget build(BuildContext context) {
    final appLocalizations = AppLocalizations.of(context);

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
              onDestinationSelected: (index) {
                setState(() => _selectedIndex = index);
              },
              labelType: NavigationRailLabelType.selected,
              destinations: [
                NavigationRailDestination(
                  icon: const Icon(Icons.home_outlined),
                  selectedIcon: const Icon(Icons.home),
                  label: Text(appLocalizations.summary),
                ),
                NavigationRailDestination(
                  icon: const Icon(Icons.sensor_door_outlined),
                  selectedIcon: const Icon(Icons.sensor_door),
                  label: Text(appLocalizations.cabins),
                ),
                NavigationRailDestination(
                  icon: const Icon(Icons.event_outlined),
                  selectedIcon: const Icon(Icons.event),
                  label: Text(appLocalizations.bookings),
                ),
              ],
            ),
            const VerticalDivider(thickness: 1, width: 1),
            Expanded(
              child: MainContent(
                railIndex: _selectedIndex,
                pages: const [
                  SummaryPage(),
                  CabinsPage(),
                  BookingsPage(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
