import 'dart:io';

import 'package:cabin_booking/app_styles.dart' as app_styles;
import 'package:cabin_booking/services/show_search_bar_intent.dart';
import 'package:cabin_booking/widgets/pages/home_page.dart';
import 'package:cabin_booking/widgets/pages/main_data_loader.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart';

class CabinBookingApp extends StatelessWidget {
  const CabinBookingApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      onGenerateTitle: (context) => AppLocalizations.of(context)!.title,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      debugShowCheckedModeBanner: false,
      scrollBehavior: const ScrollBehavior().copyWith(scrollbars: false),
      theme: app_styles.lightTheme(),
      darkTheme: app_styles.darkTheme(),
      builder: (context, child) {
        Intl.defaultLocale = Localizations.localeOf(context).toLanguageTag();

        return MediaQuery(
          data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
          child: child!,
        );
      },
      home: const _ActionableFocusedShortcuts(
        child: MainDataLoader(
          child: HomePage(),
        ),
      ),
    );
  }
}

class _ActionableFocusedShortcuts extends StatelessWidget {
  final Widget child;

  const _ActionableFocusedShortcuts({Key? key, required this.child})
      : super(key: key);

  LogicalKeySet get _searchBarLogicalKeySet => Platform.isMacOS
      ? LogicalKeySet(LogicalKeyboardKey.meta, LogicalKeyboardKey.keyK)
      : LogicalKeySet(LogicalKeyboardKey.control, LogicalKeyboardKey.keyK);

  @override
  Widget build(BuildContext context) {
    return Shortcuts(
      shortcuts: {
        _searchBarLogicalKeySet: const ShowSearchBarIntent(),
      },
      child: Actions(
        actions: {
          ShowSearchBarIntent: ShowSearchBarAction(context),
        },
        child: Focus(
          autofocus: true,
          child: child,
        ),
      ),
    );
  }
}
