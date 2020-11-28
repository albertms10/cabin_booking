class CabinComponents {
  List<Piano> pianos;
  int lecterns;
  int chairs;
  int tables;

  CabinComponents({
    this.pianos,
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
        lecterns = other['lecterns'],
        chairs = other['chairs'],
        tables = other['tables'];

  Map<String, dynamic> toMap() => {
        'pianos': pianos.map((piano) => piano.toMap()).toList(),
        'lecterns': lecterns,
        'chairs': chairs,
        'tables': tables,
      };
}

class Piano {
  String brand;
  String model;
  bool isElectronic;

  Piano({
    this.brand,
    this.model,
    this.isElectronic = false,
  });

  Piano.from(Map<String, dynamic> other)
      : brand = other['brand'],
        model = other['model'],
        isElectronic = other['isElectronic'];

  Map<String, dynamic> toMap() => {
        'brand': brand,
        'model': model,
        'isElectronic': isElectronic,
      };
}
