// ignore_for_file: public_member_api_docs, sort_constructors_first
class ServiceModel {
  String? id;
  String? air;
  String? glass;
  // String? price;
  String? polish;
  String? rim;
  String? vacuming;
  String? wash;
  String? total;

  ServiceModel({
    this.id,
    this.air,
    this.glass,
    // this.price,
    this.polish,
    this.rim,
    this.vacuming,
    this.wash,
    this.total,
  });

  // Deserialize from JSON
  factory ServiceModel.fromJson(Map<String, dynamic> json) {
    return ServiceModel(
      air: json['air'],
      // price: json['price'],
      glass: json['glass'],
      polish: json['polish'],
      rim: json['rim'],
      vacuming: json['vacuming'],
      wash: json['wash'],
      total: json['total'],
    );
  }

  // Serialize to JSON
  Map<String, dynamic> toJson() {
    return {
      'air': air,
      // 'price': price,
      'glass': glass,
      'polish': polish,
      'rim': rim,
      'vacuming': vacuming,
      'wash': wash,
      'total': total
    };
  }
}

class OfferServiceModel {
  String? id; // Document ID
  String serviceName;
  String serviceCost;
  OfferServiceModel(
      {this.id, required this.serviceName, required this.serviceCost});

  factory OfferServiceModel.fromMap(String id, Map<String, dynamic> map) {
    return OfferServiceModel(
        id: id,
        serviceName: map['serviceName'] ?? "",
        serviceCost: map['serviceCost'] ?? '');
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'serviceName': serviceName, 'serviceCost': serviceCost};
  }
}
