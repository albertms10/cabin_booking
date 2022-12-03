import 'dart:io';

import 'package:cabin_booking/app_styles.dart' as app_styles;
import 'package:cabin_booking/services/show_jump_bar_intent.dart';
import 'package:cabin_booking/widgets/pages/home_page.dart';
import 'package:cabin_booking/widgets/pages/main_data_loader.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart';

class CabinBookingApp extends StatelessWidget {
  const CabinBookingApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const _ActionableFocusedShortcuts(
        child: MainDataLoader(child: HomePage()),
      ),
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

class _ActionableFocusedShortcuts extends StatelessWidget {
  final Widget child;

  const _ActionableFocusedShortcuts({super.key, required this.child});

  LogicalKeySet get _jumpBarLogicalKeySet => Platform.isMacOS
      ? LogicalKeySet(LogicalKeyboardKey.meta, LogicalKeyboardKey.keyK)
      : LogicalKeySet(LogicalKeyboardKey.control, LogicalKeyboardKey.keyK);

  @override
  Widget build(BuildContext context) {
    return Shortcuts(
      shortcuts: {
        _jumpBarLogicalKeySet: const ShowJumpBarIntent(),
      },
      child: Actions(
        actions: {
          ShowJumpBarIntent: ShowJumpBarAction(context),
        },
        child: Focus(
          autofocus: true,
          child: child,
        ),
      ),
    );
  }
}
