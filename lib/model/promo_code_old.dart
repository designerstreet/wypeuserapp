import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:wype_user/model/add_service_model.dart';

// class PromoCodes {
//   List<Services>? promoCodes;

//   PromoCodes({this.promoCodes});

//   PromoCodes.fromJson(Map<String, dynamic> json) {
//     if (json['codes'] != null) {
//       promoCodes = <Services>[];
//       json['codes'].forEach((v) {
//         promoCodes!.add(Services.fromJson(v));
//       });
//     }
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = <String, dynamic>{};

//     if (promoCodes != null) {
//       data['codes'] = promoCodes!.map((v) => v.toJson()).toList();
//     }
//     return data;
//   }
// }

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

class PromoCodeModel {
  String id;
  String name;
  int discount;
  int price;

  PromoCodeModel({
    required this.id,
    required this.name,
    required this.discount,
    required this.price,
  });

  factory PromoCodeModel.fromDocument(DocumentSnapshot doc) {
    return PromoCodeModel(
      id: doc.id,
      name: doc['name'],
      discount: doc['discount'],
      price: doc['price'],
    );
  }

  Map toMap() {
    return {
      'name': name,
      'discount': discount,
      'price': price,
    };
  }
}
