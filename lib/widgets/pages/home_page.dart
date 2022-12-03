import 'package:cabin_booking/widgets/booking/booking_floating_action_button.dart';
import 'package:cabin_booking/widgets/cabin/cabin_floating_action_button.dart';
import 'package:cabin_booking/widgets/pages/bookings_page.dart';
import 'package:cabin_booking/widgets/pages/cabins_page.dart';
import 'package:cabin_booking/widgets/pages/school_years_page.dart';
import 'package:cabin_booking/widgets/pages/summary_page.dart';
import 'package:cabin_booking/widgets/school_year/school_year_floating_action_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final PageController _pageController = PageController();

  int get currentIndex =>
      _pageController.hasClients && _pageController.page != null
          ? _pageController.page!.floor()
          : _pageController.initialPage;

  void _setNavigationIndex(int index) {
    if (index == currentIndex) return;

    setState(() => _pageController.jumpToPage(index));
  }

  void _setNavigationPage(AppPage page) => _setNavigationIndex(page.index);

  List<_PageDestination> _pageDestinations(AppLocalizations appLocalizations) =>
      [
        _PageDestination(
          appPage: AppPage.summary,
          icon: const Icon(Icons.home_outlined),
          selectedIcon: const Icon(Icons.home),
          label: appLocalizations.summary,
          child: SummaryPage(setNavigationPage: _setNavigationPage),
        ),
        _PageDestination(
          appPage: AppPage.bookings,
          icon: const Icon(Icons.event_outlined),
          selectedIcon: const Icon(Icons.event),
          label: appLocalizations.bookings,
          floatingActionButton: const BookingFloatingActionButton(),
          child: const BookingsPage(),
        ),
        _PageDestination(
          appPage: AppPage.cabins,
          icon: const Icon(Icons.sensor_door_outlined),
          selectedIcon: const Icon(Icons.sensor_door),
          label: appLocalizations.cabins,
          floatingActionButton: const CabinFloatingActionButton(),
          child: const CabinsPage(),
        ),
        _PageDestination(
          appPage: AppPage.schoolYears,
          icon: const Icon(Icons.school_outlined),
          selectedIcon: const Icon(Icons.school),
          label: appLocalizations.schoolYears,
          floatingActionButton: const SchoolYearFloatingActionButton(),
          child: const SchoolYearsPage(),
        ),
      ];

  bool _isSmallDisplay(BuildContext context) =>
      MediaQuery.of(context).size.width < 768;

  @override
  Widget build(BuildContext context) {
    final appLocalizations = AppLocalizations.of(context)!;

    final isSmallDisplay = _isSmallDisplay(context);
    final pageDestinations = _pageDestinations(appLocalizations);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          appLocalizations.title,
          style: TextStyle(
            color: Theme.of(context).colorScheme.onPrimary,
          ),
        ),
      ),
      floatingActionButton: pageDestinations[currentIndex].floatingActionButton,
      bottomNavigationBar: isSmallDisplay
          ? BottomNavigationBar(
              currentIndex: currentIndex,
              onTap: _setNavigationIndex,
              items: [
                for (final page in pageDestinations)
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
            if (!isSmallDisplay) ...[
              NavigationRail(
                selectedIndex: currentIndex,
                onDestinationSelected: _setNavigationIndex,
                labelType: NavigationRailLabelType.selected,
                destinations: [
                  for (final page in pageDestinations)
                    NavigationRailDestination(
                      icon: page.icon,
                      selectedIcon: page.selectedIcon,
                      label: Text(page.label ?? ''),
                    ),
                ],
              ),
              const VerticalDivider(thickness: 1, width: 1),
            ],
            Expanded(
              child: PageView(
                controller: _pageController,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  for (final page in pageDestinations) page.child,
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

enum AppPage { summary, bookings, cabins, schoolYears }

class _PageDestination {
  final AppPage appPage;
  final Icon icon;
  final Icon? selectedIcon;
  final String? label;
  final Widget? floatingActionButton;
  final Widget child;

  _PageDestination({
    required this.appPage,
    required this.icon,
    this.selectedIcon,
    this.label,
    this.floatingActionButton,
    required this.child,
  });
}
