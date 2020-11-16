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
      'book': 'Reserva',
      'student': 'Estudiant',
      'edit': 'Edita',
      'previousDay': 'Dia anterior',
      'today': 'Avui',
      'nextDay': 'Dia següent',
      'start': 'Inici',
      'end': 'Final',
      'enterStudentName': 'Introdueix el nom de l’estudiant',
      'enterStartTime': 'Introdueix l’hora d’inici',
      'enterEndTime': 'Introdueix l’hora d’acabament',
      'enterValidRange': 'Introdueix un rang vàlid',
      'deleteBookingTitle': 'Confirmes que vols suprimir la reserva?',
      'actionUndone': 'Aquesta acció no es pot desfer.',
      'dataCouldNotBeLoaded': 'Les dades no s’han pogut carregar.',
    },
    'en': {
      'title': 'Cabin Booking',
      'cabin': 'Cabin',
      'booking': 'Booking',
      'book': 'Book',
      'student': 'Student',
      'edit': 'Edit',
      'previousDay': 'Previous day',
      'today': 'Today',
      'nextDay': 'Next day',
      'start': 'Start',
      'end': 'End',
      'enterStudentName': 'Enter student name',
      'enterStartTime': 'Enter start time',
      'enterEndTime': 'Enter end time',
      'enterValidRange': 'Enter a valid range',
      'deleteBookingTitle': 'Are you sure you want to delete the booking?',
      'actionUndone': 'You can’t undo this action.',
      'dataCouldNotBeLoaded': 'Data could not be loaded.',
    },
    'es': {
      'title': 'Reserva de cabinas',
      'cabin': 'Cabina',
      'booking': 'Reserva',
      'book': 'Reservar',
      'student': 'Estudiante',
      'edit': 'Editar',
      'previousDay': 'Día anterior',
      'today': 'Hoy',
      'nextDay': 'Día siguiente',
      'start': 'Inicio',
      'end': 'Final',
      'enterStudentName': 'Introduzca el nombre del / de la estudiante',
      'enterStartTime': 'Introduzca la hora de inicio',
      'enterEndTime': 'Introduzca la hora de finalización',
      'enterValidRange': 'Introduzca un rangp válido',
      'deleteBookingTitle': '¿Seguro que desea suprimir la reserva?',
      'actionUndone': 'Esta acción no se puede deshacer.',
      'dataCouldNotBeLoaded': 'Los datos no se han podido cargar.',
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

  String get book {
    return _localizedValues[locale.languageCode]['book'];
  }

  String get student {
    return _localizedValues[locale.languageCode]['student'];
  }

  String get edit {
    return _localizedValues[locale.languageCode]['edit'];
  }

  String get previousDay {
    return _localizedValues[locale.languageCode]['previousDay'];
  }

  String get today {
    return _localizedValues[locale.languageCode]['today'];
  }

  String get nextDay {
    return _localizedValues[locale.languageCode]['nextDay'];
  }

  String get start {
    return _localizedValues[locale.languageCode]['start'];
  }

  String get end {
    return _localizedValues[locale.languageCode]['end'];
  }

  String get enterStudentName {
    return _localizedValues[locale.languageCode]['enterStudentName'];
  }

  String get enterStartTime {
    return _localizedValues[locale.languageCode]['enterStartTime'];
  }

  String get enterEndTime {
    return _localizedValues[locale.languageCode]['enterEndTime'];
  }

  String get enterValidRange {
    return _localizedValues[locale.languageCode]['enterValidRange'];
  }

  String get deleteBookingTitle {
    return _localizedValues[locale.languageCode]['deleteBookingTitle'];
  }

  String get actionUndone {
    return _localizedValues[locale.languageCode]['actionUndone'];
  }

  String get dataCouldNotBeLoaded {
    return _localizedValues[locale.languageCode]['dataCouldNotBeLoaded'];
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
