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
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedNavigationIndex = 0;

  final _floatingActionButtons = const [
    SizedBox(),
    BookingFloatingActionButton(),
    CabinFloatingActionButton(),
    SchoolYearFloatingActionButton(),
  ];

  void _setNavigationIndex(int index) {
    setState(() => _selectedNavigationIndex = index);
  }

  void _setNavigationPage(AppPages page) => _setNavigationIndex(page.index);

  List<_PageDestination> _pageDestinations(AppLocalizations appLocalizations) =>
      [
        _PageDestination(
          icon: const Icon(Icons.home_outlined),
          selectedIcon: const Icon(Icons.home),
          label: appLocalizations.summary,
        ),
        _PageDestination(
          icon: const Icon(Icons.event_outlined),
          selectedIcon: const Icon(Icons.event),
          label: appLocalizations.bookings,
        ),
        _PageDestination(
          icon: const Icon(Icons.sensor_door_outlined),
          selectedIcon: const Icon(Icons.sensor_door),
          label: appLocalizations.cabins,
        ),
        _PageDestination(
          icon: const Icon(Icons.school_outlined),
          selectedIcon: const Icon(Icons.school),
          label: appLocalizations.schoolYears,
        ),
      ];

  bool _isSmallDisplay(BuildContext context) =>
      MediaQuery.of(context).size.width < 768.0;

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
      floatingActionButton: _floatingActionButtons[_selectedNavigationIndex],
      bottomNavigationBar: _isSmallDisplay(context)
          ? BottomNavigationBar(
              currentIndex: _selectedNavigationIndex,
              onTap: _setNavigationIndex,
              items: [
                for (final page in _pageDestinations(appLocalizations))
                  BottomNavigationBarItem(
                    icon: page.icon,
                    activeIcon: page.selectedIcon,
                    label: page.label,
                  ),
              ],
            )
          : null,
      body: SafeArea(
        child: Row(
          children: [
            if (!_isSmallDisplay(context)) ...[
              NavigationRail(
                selectedIndex: _selectedNavigationIndex,
                onDestinationSelected: _setNavigationIndex,
                labelType: NavigationRailLabelType.selected,
                destinations: [
                  for (final page in _pageDestinations(appLocalizations))
                    NavigationRailDestination(
                      icon: page.icon,
                      selectedIcon: page.selectedIcon,
                      label: Text(page.label ?? ''),
                    ),
                ],
              ),
              const VerticalDivider(thickness: 1.0, width: 1.0),
            ],
            Expanded(
              child: MainContent(
                railIndex: _selectedNavigationIndex,
                pages: [
                  SummaryPage(setNavigationPage: _setNavigationPage),
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

enum AppPages { summary, bookings, cabins, schoolYears }

class _PageDestination {
  final Icon icon;
  final Icon? selectedIcon;
  final String? label;

  _PageDestination({required this.icon, this.selectedIcon, this.label});
}
