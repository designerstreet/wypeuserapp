import 'package:flutter/material.dart';

class UserModel {
  String? name;
  String? profileImageUrl; // Store image as URL string
  String? contact;
  String? gender;
  int? points;
  num? wallet;
  String? id;
  String? dob;
  String lang = 'ar';

  List<Vehicle>? vehicle;

  UserModel({
    this.id,
    this.name,
    this.contact,
    this.gender,
    this.vehicle,
    this.points,
    this.profileImageUrl,
    this.dob,
    required this.lang,
    this.wallet,
  });

  UserModel.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    id = json['id'];
    lang = json['lang'];
    contact = json['contact'];
    gender = json['gender'];
    points = json['points'];
    wallet = json['wallet'];
    dob = json['dob'];
    profileImageUrl = json['profileImageUrl'];
    if (json['vehicle'] != null) {
      vehicle = <Vehicle>[];
      json['vehicle'].forEach((v) {
        vehicle!.add(Vehicle.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['id'] = id;
    data['lang'] = lang;
    data['contact'] = contact;
    data['gender'] = gender;
    data['points'] = points;
    data['wallet'] = wallet;
    data['dob'] = dob;
    data['profileImageUrl'] = profileImageUrl;
    if (vehicle != null) {
      data['vehicle'] = vehicle!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Vehicle {
  String? company;
  String? model;
  String? numberPlate;

  Vehicle({this.company, this.model, this.numberPlate});

  Vehicle.fromJson(Map<String, dynamic> json) {
    company = json['company'];
    model = json['model'];
    numberPlate = json['number_plate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['company'] = company;
    data['model'] = model;
    data['number_plate'] = numberPlate;
    return data;
  }
}
