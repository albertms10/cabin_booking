import 'package:cabin_booking/app_styles.dart' as app_styles;
import 'package:cabin_booking/widgets/pages/home_page.dart';
import 'package:cabin_booking/widgets/pages/main_data_loader.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart';

class CabinBookingApp extends StatelessWidget {
  const CabinBookingApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const MainDataLoader(child: HomePage()),
      builder: (context, child) {
        Intl.defaultLocale = Localizations.localeOf(context).toLanguageTag();

        return MediaQuery(
          data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
          child: child!,
        );
      },
      onGenerateTitle: (context) => AppLocalizations.of(context)!.title,
      theme: app_styles.lightTheme(),
      darkTheme: app_styles.darkTheme(),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      debugShowCheckedModeBanner: false,
      scrollBehavior: const ScrollBehavior().copyWith(scrollbars: false),
    );
  }
}
