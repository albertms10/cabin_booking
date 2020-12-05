import 'package:cabin_booking/model/cabin_manager.dart';
import 'package:cabin_booking/model/day_handler.dart';
import 'package:cabin_booking/widgets/pages/home_page.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart';
import 'package:intl/intl_standalone.dart';
import 'package:provider/provider.dart';

void main() async {
  if (kIsWeb) {
    await findSystemLocale();
  } else {
    Intl.defaultLocale = 'ca';
  }

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
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('ca'),
        Locale('en'),
        Locale('es'),
      ],
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: HomePage(),
    );
  }
}
