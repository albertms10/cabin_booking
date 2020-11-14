import 'package:flutter/foundation.dart' show SynchronousFuture;
import 'package:flutter/material.dart';

class AppLocalizations {
  final Locale locale;

  AppLocalizations(this.locale);

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static Map<String, Map<String, String>> _localizedValues = {
    'ca': {
      'title': 'Reserva de cabines',
      'cabin': 'Cabina',
      'booking': 'Reserva',
      'edit': 'Editar',
      'delete': 'Eliminar',
    },
    'en': {
      'title': 'Cabin Booking',
      'cabin': 'Cabin',
      'booking': 'Booking',
      'edit': 'Edit',
      'delete': 'Delete',
    },
    'es': {
      'title': 'Reserva de cabinas',
      'cabin': 'Cabina',
      'booking': 'Reserva',
      'edit': 'Editar',
      'delete': 'Eliminar',
    },
  };

  String get title {
    return _localizedValues[locale.languageCode]['title'];
  }

  String get cabin {
    return _localizedValues[locale.languageCode]['cabin'];
  }

  String get booking {
    return _localizedValues[locale.languageCode]['booking'];
  }

  String get edit {
    return _localizedValues[locale.languageCode]['edit'];
  }

  String get delete {
    return _localizedValues[locale.languageCode]['delete'];
  }
}

class AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) =>
      const ['ca', 'en', 'es'].contains(locale.languageCode);

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(AppLocalizations(locale));
  }

  @override
  bool shouldReload(AppLocalizationsDelegate old) => false;
}
