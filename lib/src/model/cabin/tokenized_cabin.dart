import 'package:cabin_booking/utils/app_localizations_extension.dart';
import 'package:cabin_booking/utils/iterable_string_extension.dart';
import 'package:flutter/foundation.dart' show immutable;
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'cabin.dart';

/// A tokenized representation of a [Cabin].
@immutable
class TokenizedCabin {
  /// The number of the Cabin.
  final String? cabinNumber;

  /// Creates a new [TokenizedCabin] from the required tokens.
  const TokenizedCabin({this.cabinNumber});

  /// Creates a new [TokenizedCabin] from a Map of tokens.
  TokenizedCabin.fromTokens(Map<String, String?> tokens)
      : cabinNumber = tokens['cabinNumber'];

  /// Regular expressions to obtain the required tokens to construct this
  /// [TokenizedCabin].
  static List<RegExp> expressions(AppLocalizations appLocalizations) => [
        RegExp(
          '(?:${appLocalizations.cabinTerms.union})'
          r'\W*(?<cabinNumber>\d+)',
          caseSensitive: false,
        ),
      ];

  /// Creates a new [Cabin] from this [TokenizedCabin].
  Cabin toCabin() => Cabin(number: int.parse(cabinNumber ?? '0'));

  @override
  bool operator ==(Object other) =>
      other is TokenizedCabin && cabinNumber == other.cabinNumber;

  @override
  int get hashCode => cabinNumber.hashCode;
}
