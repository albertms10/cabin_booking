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
      'cabins': 'Cabines',
      'booking': 'Reserva',
      'bookings': 'Reserves',
      'recurringBooking': 'Reserva periòdica',
      'recurringBookings': 'Reserves periòdiques',
      'lockedRange': 'Rang bloquejat',
      'book': 'Reserva',
      'student': 'Estudiant',
      'add': 'Afegeix',
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
      'occupied': 'Espai ocupat',
      'deleteBookingTitle': 'Confirmes que vols suprimir la reserva?',
      'actionUndone': 'Aquesta acció no es pot desfer.',
      'dataCouldNotBeLoaded': 'Les dades no s’han pogut carregar.',
      'changesSaved': 'S’han desat els canvis',
      'disabled': 'Desactivada',
      'description': 'Descripció',
      'occupancyRate': 'Ocupació',
    },
    'en': {
      'title': 'Cabin Booking',
      'cabin': 'Cabin',
      'cabins': 'Cabins',
      'booking': 'Booking',
      'bookings': 'Bookings',
      'recurringBooking': 'Recurring booking',
      'recurringBookings': 'Recurring bookings',
      'lockedRange': 'Locked range',
      'book': 'Book',
      'student': 'Student',
      'add': 'Add',
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
      'occupied': 'Occupied',
      'deleteBookingTitle': 'Are you sure you want to delete the booking?',
      'actionUndone': 'You can’t undo this action.',
      'dataCouldNotBeLoaded': 'Data could not be loaded.',
      'changesSaved': 'Changes saved',
      'disabled': 'disabled',
      'description': 'Description',
      'occupancyRate': 'Occupancy rate',
    },
    'es': {
      'title': 'Reserva de cabinas',
      'cabin': 'Cabina',
      'cabins': 'Cabinas',
      'booking': 'Reserva',
      'bookings': 'Reservas',
      'recurringBooking': 'Reserva periódica',
      'recurringBookings': 'Reservas periódicas',
      'lockedRange': 'Rango bloqueado',
      'book': 'Reservar',
      'student': 'Estudiante',
      'add': 'Añadir',
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
      'occupied': 'Espacio ocupado',
      'deleteBookingTitle': '¿Seguro que desea suprimir la reserva?',
      'actionUndone': 'Esta acción no se puede deshacer.',
      'dataCouldNotBeLoaded': 'Los datos no se han podido cargar.',
      'changesSaved': 'Se han guardado los cambios',
      'disabled': 'Desactivada',
      'description': 'Descripción',
      'occupancyRate': 'Ocupación',
    },
  };

  String get title => _localizedValues[locale.languageCode]['title'];

  String get cabin => _localizedValues[locale.languageCode]['cabin'];

  String get cabins => _localizedValues[locale.languageCode]['cabins'];

  String get booking => _localizedValues[locale.languageCode]['booking'];

  String get bookings => _localizedValues[locale.languageCode]['bookings'];

  String get recurringBooking =>
      _localizedValues[locale.languageCode]['recurringBooking'];

  String get recurringBookings =>
      _localizedValues[locale.languageCode]['recurringBookings'];

  String get book => _localizedValues[locale.languageCode]['book'];

  String get student => _localizedValues[locale.languageCode]['student'];

  String get add => _localizedValues[locale.languageCode]['add'];

  String get edit => _localizedValues[locale.languageCode]['edit'];

  String get previousDay =>
      _localizedValues[locale.languageCode]['previousDay'];

  String get today => _localizedValues[locale.languageCode]['today'];

  String get nextDay => _localizedValues[locale.languageCode]['nextDay'];

  String get start => _localizedValues[locale.languageCode]['start'];

  String get end => _localizedValues[locale.languageCode]['end'];

  String get enterStudentName =>
      _localizedValues[locale.languageCode]['enterStudentName'];

  String get enterStartTime =>
      _localizedValues[locale.languageCode]['enterStartTime'];

  String get enterEndTime =>
      _localizedValues[locale.languageCode]['enterEndTime'];

  String get enterValidRange =>
      _localizedValues[locale.languageCode]['enterValidRange'];

  String get occupied => _localizedValues[locale.languageCode]['occupied'];

  String get deleteBookingTitle =>
      _localizedValues[locale.languageCode]['deleteBookingTitle'];

  String get actionUndone =>
      _localizedValues[locale.languageCode]['actionUndone'];

  String get dataCouldNotBeLoaded =>
      _localizedValues[locale.languageCode]['dataCouldNotBeLoaded'];

  String get changesSaved =>
      _localizedValues[locale.languageCode]['changesSaved'];

  String get disabled => _localizedValues[locale.languageCode]['disabled'];

  String get description =>
      _localizedValues[locale.languageCode]['description'];

  String get lockedRange =>
      _localizedValues[locale.languageCode]['lockedRange'];

  String get occupancyRate =>
      _localizedValues[locale.languageCode]['occupancyRate'];
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
