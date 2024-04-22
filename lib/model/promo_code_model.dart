import 'package:wype_user/model/add_service_model.dart';

class PromoCodes {
  List<Services>? promoCodes;

  PromoCodes({this.promoCodes});

  PromoCodes.fromJson(Map<String, dynamic> json) {
    if (json['codes'] != null) {
      promoCodes = <Services>[];
      json['codes'].forEach((v) {
        promoCodes!.add(Services.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};

    if (promoCodes != null) {
      data['codes'] = promoCodes!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Services {
  num? price;
  String? subtitle;
  String? name;

  Services({this.price, this.subtitle, this.name});

  Services.fromJson(Map<String, dynamic> json) {
    price = json['price'];
    subtitle = json['subtitle'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['price'] = price;
    data['subtitle'] = subtitle;
    data['name'] = name;
    return data;
  }
}

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
