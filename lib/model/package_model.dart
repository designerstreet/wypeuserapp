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
//   int getPriceForWash(String noOfWash) {
//     return pricing[noOfWash] ?? 0;
//   }
// }
class Package {
  String? id; // Document ID
  String? name; // Document ID

  final List<String>? cost;
  final List<String>? noOfWash;
  String? offerService;
  String addService;
  String? description;
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
    this.description,
    required this.notes,
    this.package,
    this.dueration,
  });

  factory Package.fromMap(String id, Map<String, dynamic> map) {
    return Package(
      id: id,
      name: map['name'] ?? "",
      dueration: map['dueration'] ?? "",
      addService: map['addService'] ?? "",
      offerService: map['offerService'] ?? "",
      description: map['description'] ?? "",
      noOfWash: (map['noOfWash'] as List<dynamic>?)
              ?.map((noOfWash) => noOfWash.toString())
              .toList() ??
          [],
      cost: (map['cost'] as List<dynamic>?)
              ?.map((cost) => cost.toString())
              .toList() ??
          [],
      notes: map['notes'] ?? "",
      package: map['package'] ?? "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'cost': cost ?? '',
      'addService': addService,
      'description': description,
      'noOfWash': noOfWash ?? '',
      'notes': notes,
      'dueration': dueration,
      'package': package,
      'offerService': offerService
    };
  }

  static fromJson(package) {}
}
