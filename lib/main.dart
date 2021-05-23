import 'package:cabin_booking/app_styles.dart';
import 'package:cabin_booking/model/cabin_manager.dart';
import 'package:cabin_booking/model/day_handler.dart';
import 'package:cabin_booking/widgets/pages/home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

void main() async {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => DayHandler()),
        ChangeNotifierProvider(create: (context) => CabinManager()),
      ],
      child: const CabinBookingApp(),
    ),
  );
}

class CabinBookingApp extends StatelessWidget {
  const CabinBookingApp();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      onGenerateTitle: (context) => AppLocalizations.of(context)!.title,
      localizationsDelegates: const [
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
      theme: AppStyles.lightTheme(),
      darkTheme: AppStyles.darkTheme(),
      builder: (context, child) {
        Intl.defaultLocale = Localizations.localeOf(context).toLanguageTag();

        return MediaQuery(
          data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
          child: child!,
        );
      },
      home: const HomePage(),
    );
  }
}
