class Rate {
  Rate({
    required this.base,
    required this.timeStamp,
    required this.rates,
    required this.unit,
  });

  static final Rate origin = Rate(base: "", timeStamp: "", rates: {}, unit: "");

  String base;
  String timeStamp;
  Map<String, dynamic> rates;
  String unit;

  factory Rate.create() {
    return origin;
  }

  factory Rate.fromJson(Map json) {
    var data = json['data'];
    return Rate(
      base: data['base'],
      timeStamp: data['timestamp'],
      rates: data['rates'],
      unit: data['unit'],
    );
  }
}
