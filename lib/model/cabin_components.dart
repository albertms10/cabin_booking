class CabinComponents {
  late final List<Piano> pianos;
  int lecterns;
  int chairs;
  int tables;

  CabinComponents({
    List<Piano>? pianos,
    this.lecterns = 0,
    this.chairs = 0,
    this.tables = 0,
  }) {
    pianos ??= <Piano>[];
  }

  CabinComponents.from(Map<String, dynamic> other)
      : pianos = (other['pianos'] as List<dynamic>)
            .map((piano) => Piano.from(piano))
            .toList(),
        lecterns = other['lecterns'] as int,
        chairs = other['chairs'] as int,
        tables = other['tables'] as int;

  Map<String, dynamic> toMap() => {
        'pianos': pianos.map((piano) => piano.toMap()).toList(),
        'lecterns': lecterns,
        'chairs': chairs,
        'tables': tables,
      };
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
      : brand = other['brand'] as String?,
        model = other['model'] as String?,
        isElectronic = other['isElectronic'] as bool;

  Map<String, dynamic> toMap() => {
        'brand': brand,
        'model': model,
        'isElectronic': isElectronic,
      };
}
