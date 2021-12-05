abstract class _JsonFields {
  static const brand = 'b';
  static const model = 'm';
  static const isElectronic = 'ie';
}

class Piano {
  String? brand;
  String? model;
  bool isElectronic;

  Piano({
    this.brand,
    this.model,
    this.isElectronic = false,
  });

  Piano.from(Map<String, dynamic> other)
      : brand = other[_JsonFields.brand] as String?,
        model = other[_JsonFields.model] as String?,
        isElectronic = other[_JsonFields.isElectronic] as bool;

  Map<String, dynamic> toJson() => {
        _JsonFields.brand: brand,
        _JsonFields.model: model,
        _JsonFields.isElectronic: isElectronic,
      };
}
