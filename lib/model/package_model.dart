import 'package:wype_user/model/add_service_model.dart';

class Package {
  final String name;
  final String about;
  final Map<String, dynamic> pricing;
  final List<String> services;
  List<ServiceModel>? addServices;
  List<ServiceModel>? removeServices;

  Package(
      {required this.name,
      required this.about,
      required this.pricing,
      required this.services,
      this.addServices,
      this.removeServices});

  factory Package.fromJson(Map<String, dynamic> json) {
    return Package(
      name: json['name'] ?? '',
      about: json['about'] ?? '',
      pricing: json['pricing'] ?? {},
      services: List<String>.from(json['services'] ?? []),
      addServices:
          List<ServiceModel>.from((json['addServices'] as List<dynamic>?)?.map(
                (service) => ServiceModel.fromJson(service),
              ) ??
              []),
      removeServices: List<ServiceModel>.from(
          (json['removeServices'] as List<dynamic>?)?.map(
                (service) => ServiceModel.fromJson(service),
              ) ??
              []),
    );
  }
  int getPriceForWash(String washType) {
    return pricing[washType] ?? 0;
  }
}
