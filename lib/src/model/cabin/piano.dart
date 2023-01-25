import 'package:flutter/foundation.dart';

import '../serializable.dart';

abstract class _JsonFields {
  static const brand = 'b';
  static const model = 'm';
  static const isElectronic = 'ie';
}

/// A piano.
@immutable
class Piano implements Serializable {
  final String? brand;
  final String? model;
  final bool isElectronic;

  /// Creates a new [Piano].
  const Piano({
    this.brand,
    this.model,
    this.isElectronic = false,
  });

  /// Creates a new [Piano] from a JSON Map.
  Piano.fromJson(Map<String, dynamic> other)
      : brand = other[_JsonFields.brand] as String?,
        model = other[_JsonFields.model] as String?,
        isElectronic = other[_JsonFields.isElectronic] as bool;

  @override
  Map<String, dynamic> toJson() => {
        _JsonFields.brand: brand,
        _JsonFields.model: model,
        _JsonFields.isElectronic: isElectronic,
      };

  @override
  bool operator ==(Object other) =>
      other is Piano &&
      brand == other.brand &&
      model == other.model &&
      isElectronic == other.isElectronic;

  @override
  int get hashCode => Object.hash(brand, model, isElectronic);
}
