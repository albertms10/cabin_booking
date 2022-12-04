// ignore_for_file: comment_references
import 'package:cabin_booking/constants.dart';
import 'package:cabin_booking/utils/app_localizations_extension.dart';
import 'package:cabin_booking/utils/date_time_extension.dart';
import 'package:cabin_booking/utils/iterable_string_extension.dart';
import 'package:cabin_booking/utils/time_of_day_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'single_booking.dart';

/// A tokenized representation of a [Booking].
@immutable
class TokenizedBooking {
  /// One of [AppLocalizationsExtension.relativeDays].
  final String? relativeDay;

  /// `'19:00'`.
  final String? startTime;

  /// Will be non-null only if [startTime] is provided.
  ///
  /// `'20:00'`.
  final String? endTime;

  /// Integer value for the first part of the duration.
  ///
  /// ```
  /// '1 h 30 min'
  ///  ^
  /// ```
  final String? durationValue1;

  /// Unit for the first part of the duration.
  /// One of [AppLocalizationsExtension.timeUnits].
  ///
  /// ```
  /// '1 h 30 min'
  ///    ^
  /// ```
  final String? durationUnit1;

  /// Integer value for the second part of the duration.
  ///
  /// ```
  /// '1 h 30 min'
  ///      ^^
  /// ```
  final String? durationValue2;

  /// One of [AppLocalizationsExtension.timeUnits].
  ///
  /// ```
  /// '1 h 30 min'
  ///         ^^^
  /// ```
  final String? durationUnit2;

  /// One of [AppLocalizationsExtension.periodicityTerms].
  final String? periodicity;

  /// Creates a new [TokenizedBooking] from the required tokens.
  const TokenizedBooking({
    this.relativeDay,
    this.startTime,
    this.endTime,
    this.durationValue1,
    this.durationUnit1,
    this.durationValue2,
    this.durationUnit2,
    this.periodicity,
  });

  /// Creates a new [TokenizedBooking] from a Map of tokens.
  TokenizedBooking.fromTokens(Map<String, String?> tokens)
      : relativeDay = tokens['relativeDay'],
        startTime = tokens['startTime'],
        endTime = tokens['endTime'],
        durationValue1 = tokens['durationValue1'],
        durationUnit1 = tokens['durationUnit1'],
        durationValue2 = tokens['durationValue2'],
        durationUnit2 = tokens['durationUnit2'],
        periodicity = tokens['periodicity'];

  /// Regular expressions to obtain the required tokens to construct this
  /// [TokenizedBooking].
  static List<RegExp> expressions(AppLocalizations appLocalizations) => [
        RegExp(
          '(?<relativeDay>${appLocalizations.relativeDays.union})',
          caseSensitive: false,
        ),
        RegExp('(?<startTime>$timeExpression)'),
        RegExp(
          '(?<startTime>$timeExpression)(?:.*?)(?<endTime>$timeExpression)',
          dotAll: true,
        ),
        RegExp(
          r'(?<durationValue1>\d+)\W*'
          '(?<durationUnit1>${appLocalizations.timeUnits.union})',
          caseSensitive: false,
        ),
        RegExp(
          r'(?<durationValue1>\d+)\W*'
          '(?<durationUnit1>${appLocalizations.timeUnits.union})'
          r'(:?.*?)(?<durationValue2>\d+)\W*'
          '(?<durationUnit2>${appLocalizations.timeUnits.union})',
          caseSensitive: false,
          dotAll: true,
        ),
        RegExp(
          '(?<periodicity>${appLocalizations.periodicityTerms.union})',
          caseSensitive: false,
        ),
      ];

  /// Creates a new [SingleBooking] from this [TokenizedBooking].
  SingleBooking toSingleBooking(AppLocalizations appLocalizations) {
    var startTime = TimeOfDayExtension.tryParse(this.startTime ?? '');

    TimeOfDay? endTime;
    if (this.endTime != null) {
      endTime = TimeOfDayExtension.tryParse(this.endTime ?? '');
    } else {
      final duration1 = _durationFromTokens(
        appLocalizations,
        value: durationValue1,
        unit: durationUnit1,
      );
      final duration2 = _durationFromTokens(
        appLocalizations,
        value: durationValue2,
        unit: durationUnit2,
      );

      final totalDuration = duration1 + duration2;
      // If duration is 0, default to `defaultSlotDuration`.
      final duration =
          totalDuration.inMinutes > 0 ? totalDuration : defaultSlotDuration;
      endTime = startTime?.increment(minutes: duration.inMinutes);

      // Limit maximum endTime to 23:59.
      if (startTime != null && endTime != null) {
        if (endTime.difference(startTime).isNegative) {
          endTime = const TimeOfDay(hour: 23, minute: 59);
        }
      }
    }

    final now = DateTime.now();
    if (startTime == null || endTime == null) {
      final nearestTimeOfDay = TimeOfDay.fromDateTime(now).roundToNearest(15);
      startTime = nearestTimeOfDay;
      endTime = nearestTimeOfDay.increment(hours: defaultSlotDuration.inHours);
    }

    return SingleBooking(
      startDateTime: now.addTimeOfDay(startTime),
      endDateTime: now.addTimeOfDay(endTime),
    );
  }

  static Duration _durationFromTokens(
    AppLocalizations appLocalizations, {
    String? value,
    String? unit,
  }) {
    final amount = int.tryParse(value ?? '');

    if (appLocalizations.minuteUnits.contains(unit)) {
      return Duration(minutes: amount ?? 0);
    }

    return Duration(hours: amount ?? 0);
  }
}
