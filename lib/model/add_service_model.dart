class ServiceModel {
  String? name;
  String? subtitle;
  int? price;

  ServiceModel({this.name, this.price, this.subtitle});

  // Deserialize from JSON
  factory ServiceModel.fromJson(Map<String, dynamic> json) {
    return ServiceModel(
        name: json['name'], price: json['price'], subtitle: json['subtitle']);
  }

  // Serialize to JSON
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'price': price,
      'subtitle': subtitle,
    };
  }
}
