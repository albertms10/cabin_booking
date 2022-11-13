import 'package:cabin_booking/utils/app_localizations_extension.dart';
import 'package:cabin_booking/utils/iterable_string_extension.dart';
import 'package:flutter/foundation.dart' show immutable;
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

@immutable
class TokenizedCabin {
  final String? cabinNumber;

  const TokenizedCabin({this.cabinNumber});

  TokenizedCabin.fromTokens(Map<String, String?> tokens)
      : cabinNumber = tokens['cabinNumber'];

  static List<RegExp> expressions(AppLocalizations appLocalizations) => [
        RegExp(
          '(?:${appLocalizations.cabinTerms.union})'
          r'\W*(?<cabinNumber>\d+)',
          caseSensitive: false,
        ),
      ];
}
