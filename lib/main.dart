import 'package:cabin_booking/l10n/app_localizations.dart';
import 'package:cabin_booking/widgets/booking/booking_floating_action_button.dart';
import 'package:cabin_booking/widgets/layout/day_navigation.dart';
import 'package:cabin_booking/widgets/layout/time_table.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart';
import 'package:intl/intl_standalone.dart';
import 'package:provider/provider.dart';

import 'model/cabin_manager.dart';
import 'model/day_handler.dart';

void main() async {
  if (kIsWeb)
    await findSystemLocale();
  else
    Intl.defaultLocale = 'ca';

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<CabinManager>(
          create: (context) => CabinManager(),
        ),
        ChangeNotifierProvider<DayHandler>(
          create: (context) => DayHandler(),
        ),
      ],
      child: CabinBookingApp(),
    ),
  );
}

class CabinBookingApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      onGenerateTitle: (BuildContext context) =>
          AppLocalizations.of(context).title,
      localizationsDelegates: [
        const AppLocalizationsDelegate(),
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('ca'),
        Locale('en'),
        Locale('es'),
      ],
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).title),
      ),
      floatingActionButton: BookingFloatingActionButton(),
      body: SafeArea(
        child: Column(
          children: [
            DayNavigation(),
            TimeTable(),
          ],
        ),
      ),
    );
  }
}
