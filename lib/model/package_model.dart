// import 'package:wype_user/model/add_service_model.dart';

// class Package {
//   final String about;
//   final Map<String, dynamic> pricing;
//   final List<String> services;
//   List<ServiceModel>? addServices;
//   List<ServiceModel>? removeServices;
//   String? id; // Document ID
//   String? name; // Document Name
//   String? cost;
//   String noOfWash;
//   String? offerService;
//   String addService;
//   // String? removeService;
//   String notes;
//   String? dueration;
//   String? package;

//   Package(
//       {required this.name,
//       required this.about,
//       required this.pricing,
//       required this.services,
//       this.addServices,
//       this.removeServices});

//   factory Package.fromJson(Map<String, dynamic> json) {
//     return Package(
//       name: json['name'] ?? '',
//       about: json['about'] ?? '',
//       pricing: json['pricing'] ?? {},
//       services: List<String>.from(json['services'] ?? []),
//       addServices:
//           List<ServiceModel>.from((json['addServices'] as List<dynamic>?)?.map(
//                 (service) => ServiceModel.fromJson(service),
//               ) ??
//               []),
//       removeServices: List<ServiceModel>.from(
//           (json['removeServices'] as List<dynamic>?)?.map(
//                 (service) => ServiceModel.fromJson(service),
//               ) ??
//               []),
//     );
//   }
//   int getPriceForWash(String washType) {
//     return pricing[washType] ?? 0;
//   }
// }
class Package {
  String? id; // Document ID
  String? name; // Document ID
  String? cost;
  String noOfWash;
  String? offerService;
  String addService;
  // String? removeService;
  String notes;
  String? dueration;
  String? package;

  Package({
    this.id,
    required this.name,
    this.cost,
    required this.noOfWash,
    required this.addService,
    this.offerService,
    // this.removeService,
    required this.notes,
    this.package,
    this.dueration,
  });

  factory Package.fromMap(String id, Map<String, dynamic> map) {
    return Package(
      id: id,
      name: map['name'] ?? "",
      dueration: map['dueration'] ?? "",
      cost: map['cost'] ?? "",
      addService: map['addService'] ?? "",
      offerService: map['offerService'] ?? "",

      // removeService: map['removeService'] ?? "",
      noOfWash: map['noOfWash'] ?? "",
      notes: map['notes'] ?? "",
      package: map['package'] ?? "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'cost': cost,
      'addService': addService,
      // 'removeService': removeService,
      'noOfWash': noOfWash,
      'notes': notes,
      'dueration': dueration,
      'package': package,
      'offerService': offerService
    };
  }

  static fromJson(package) {}
}
