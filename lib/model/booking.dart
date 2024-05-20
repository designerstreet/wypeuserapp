// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:wype_user/model/user_model.dart';

class BookingModel {
  String? bookingID; // Document bookingID
  String bookingStatus;
  String? name;
  String serviceType;
  String userId;
  String address;
  Vehicle vehicle;
  var slotDate;
  String washCount;
  // String noOfWash;
  String? washTimings;
  LatLngModel latlong;
  List<String> addService;
  List<String> removeService;
  // String? comments;

  BookingModel({
    // this.comments,
    this.bookingID,
    required this.bookingStatus,
    this.name,
    required this.serviceType,
    required this.userId,
    required this.address,
    required this.vehicle,
    required this.slotDate,
    required this.washCount,
    this.washTimings,
    required this.latlong,
    required this.addService,
    required this.removeService,
  });

  factory BookingModel.fromMap(String bookingID, Map<String, dynamic> map) {
    return BookingModel(
      bookingID: bookingID,
      address: map['address'] ?? "",
      name: map['name'] ?? "",
      latlong: LatLngModel.fromJson(map['latlong']),
      bookingStatus: map['booking_status'] ?? '',
      serviceType: map['service_type'] ?? '',
      userId: map['user_id'] ?? '',
      slotDate: map['slotDate'] ?? '[]',
      vehicle: Vehicle.fromJson(map['vehicle'] ?? {}),
      // washCount: map['wash_count'] ?? 0,
      washTimings: (map['wash_timings']),
      addService: (map['add_service'] as List<dynamic>?)
              ?.map((service) => service.toString())
              .toList() ??
          [],
      removeService: (map['remove_service'] as List<dynamic>?)
              ?.map((service) => service.toString())
              .toList() ??
          [],
      washCount: map['wash_count'] ?? '',
      // comments: map['comments'] ?? ""
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'bookingID': bookingID,
      'name': name,
      'booking_status': bookingStatus,
      'service_type': serviceType,
      'user_id': userId,
      'address': address,
      'vehicle': vehicle.toJson(),
      'wash_count': washCount,
      'wash_timings': washTimings,
      'latlong': latlong.toJson(),
      'add_service': addService,
      'remove_service': removeService,
      // 'comments': comments,
      'slotDate': slotDate
    };
  }
}

class LatLngModel {
  double lat;
  double long;

  LatLngModel({
    required this.lat,
    required this.long,
  });

  factory LatLngModel.fromJson(Map<String, dynamic> json) {
    return LatLngModel(
      lat: json['lat'],
      long: json['long'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'lat': lat,
      'long': long,
    };
  }
}
