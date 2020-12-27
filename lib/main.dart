import 'package:cabin_booking/model/cabin_manager.dart';
import 'package:cabin_booking/model/day_handler.dart';
import 'package:cabin_booking/model/school_year_manager.dart';
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
        ChangeNotifierProvider(create: (context) => SchoolYearManager()),
        ChangeNotifierProvider(create: (context) => CabinManager()),
        ChangeNotifierProvider(create: (context) => DayHandler()),
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
      onGenerateTitle: (context) => AppLocalizations.of(context).title,
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
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
          child: child,
        );
      },
      home: const HomePage(),
    );
  }
}

class AppStyles {
  static ThemeData themeData() {
    return ThemeData(
      inputDecorationTheme: const InputDecorationTheme(
        filled: true,
        errorMaxLines: 2,
        border: OutlineInputBorder(),
      ),
    );
  }

  static ThemeData lightTheme() {
    final primaryColor = themeData().primaryColor;

    return ThemeData.light().copyWith(
      primaryColor: primaryColor,
      accentColor: primaryColor,
    );
  }

  static ThemeData darkTheme() {
    final primaryColor = Colors.teal;
    final primaryColorLight = Colors.teal[300];
    final primaryColorDark = Colors.teal[700];

    return ThemeData.dark().copyWith(
      primaryColor: primaryColor,
      primaryColorLight: primaryColorLight,
      primaryColorDark: primaryColorDark,
      accentColor: primaryColor,
      colorScheme: ColorScheme.dark(
        primary: primaryColor,
        primaryVariant: primaryColorLight,
        secondary: primaryColor,
        secondaryVariant: primaryColorDark,
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: primaryColor,
      ),
      toggleableActiveColor: primaryColor,
      navigationRailTheme: NavigationRailThemeData(
        selectedIconTheme: IconThemeData(color: primaryColor),
        selectedLabelTextStyle: TextStyle(color: primaryColor),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all<Color>(primaryColor),
        ),
      ),
    );
  }
}
