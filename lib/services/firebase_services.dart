import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:wype_user/auth/login_page.dart';
import 'package:wype_user/auth/verify_otp.dart';
import 'package:wype_user/constants.dart';
import 'package:wype_user/model/add_package_model.dart';
import 'package:wype_user/model/add_service_model.dart';
import 'package:wype_user/model/booking.dart';
import 'package:wype_user/model/employee_model.dart';
import 'package:wype_user/model/package_model.dart';
import 'package:wype_user/model/shift_model.dart';
import 'package:wype_user/model/user_model.dart';

import '../home/root.dart';
import '../model/promo_code_model.dart';
import '../model/saved_location_model.dart';

final FirebaseFirestore _firestore = FirebaseFirestore.instance;

class FirebaseService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Function to check if user document exists in Firestore
  Future<bool> _doesUserDocumentExist(String userId) async {
    DocumentSnapshot snapshot =
        await FirebaseFirestore.instance.collection('users').doc(userId).get();
    return snapshot.exists;
  }

  // Function to create user document in Firestore
  Future<void> _createUserDocument(
      String userId, Map<String, dynamic> userData) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .set(userData);
  }

  // Callback when verification is completed automatically
  void _onVerificationCompleted() {}

  Future<void> login(
    BuildContext context,
    bool isNewUser,
    String? name,
    String? phone,
    String? gender,
    String? password,
    String? profileImage,
    String? dob,
    String lang,
  ) async {
    UserCredential authResult;
    if (isNewUser) {
      authResult = await _auth.createUserWithEmailAndPassword(
          email: "${phone!.trim()}@wype.com", password: password!);
    } else {
      authResult = await _auth.signInWithEmailAndPassword(
          email: "${phone!.trim()}@wype.com", password: password!);
    }
    String userId = authResult.user!.uid;

    bool userExists = await _doesUserDocumentExist(userId);

    if (!userExists) {
      if (!isNewUser) {
        toast("User not found. Please Sign up");
      } else {
        if (name != null) {
          await _createUserDocument(
              userId,
              UserModel(
                  id: userId,
                  name: name,
                  contact: phone,
                  gender: gender,
                  points: 0,
                  wallet: 0,
                  profileImageUrl: profileImage,
                  dob: dob,
                  lang: lang,
                  vehicle: []).toJson());
          Get.offAll(const LoginPage());
        }
      }
    } else {
      const RootPage()
          .launch(context, pageRouteAnimation: PageRouteAnimation.Fade);
    }

    // Navigate to the next page or perform other actions as needed
  }

  // Callback when the user manually enters the OTP
  Future<void> onOtpEntered(
    String otp,
    String verificationId,
    BuildContext context,
    bool isNewUser,
    String? name,
    String? email,
    String? gender,
    String lang,
  ) async {
    try {
      UserCredential authResult =
          await _auth.signInWithEmailAndPassword(email: "", password: "");
      String userId = authResult.user!.uid;

      bool userExists = await _doesUserDocumentExist(userId);

      if (!userExists) {
        if (!isNewUser) {
          toast("User not found. Please Sign up");
        } else {
          if (name != null) {
            await _createUserDocument(
                userId,
                UserModel(
                    id: userId,
                    name: name,
                    lang: lang,
                    // contact: number,
                    gender: gender,
                    vehicle: []).toJson());
            const RootPage()
                .launch(context, pageRouteAnimation: PageRouteAnimation.Fade);
          }
        }
      } else {
        const RootPage()
            .launch(context, pageRouteAnimation: PageRouteAnimation.Fade);
      }

      // Navigate to the next page or perform other actions as needed
    } catch (e) {
      toast("The sms code has expired");
      print('Error during OTP verification: $e');
      // Handle verification error
    }
  }

  List<Vehicle>? _parseVehicles(List<dynamic>? vehicleList) {
    if (vehicleList == null || vehicleList.isEmpty) {
      return [];
    }

    return vehicleList
        .map((vehicleData) => Vehicle(
              model: vehicleData['model'],
              company: vehicleData['company'],
              numberPlate: vehicleData['number_plate'],
            ))
        .toList();
  }

  Future<void> deleteSavedLocation(
      String userId, SavedLocation locationToDelete) async {
    try {
      // Fetch the current list of saved locations
      DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
          .collection('saved_location')
          .doc(userId)
          .get();

      if (!documentSnapshot.exists) {
        print('Document does not exist');
        return;
      }

      List<dynamic> locations = documentSnapshot['locations'];
      locations.removeWhere((location) =>
          location['address'] == locationToDelete.address &&
          location['latitude'] == locationToDelete.latitude &&
          location['longitude'] == locationToDelete.longitude);

      // Update the document with the modified list of saved locations
      await FirebaseFirestore.instance
          .collection('saved_location')
          .doc(userId)
          .update({'locations': locations});

      print('Location deleted successfully');
    } catch (error) {
      print('Error deleting location: $error');
      // Handle the error accordingly
    }
  }

  Stream<List<SavedLocation>> getSavedLocations(String userId) {
    return FirebaseFirestore.instance
        .collection('saved_location')
        .doc(userId)
        .snapshots()
        .map((snapshot) {
      if (!snapshot.exists) {
        return [];
      }

      var data = snapshot.data() as Map<String, dynamic>;
      var locations = data['locations'] as List<dynamic>;

      return locations.map((location) {
        return SavedLocation(
          id: snapshot.id,
          address: location['address'],
          latitude: location['latitude'],
          longitude: location['longitude'],
        );
      }).toList();
    });
  }

  Future<UserModel?> getUserDetails() async {
    User? user = _auth.currentUser;

    if (user != null) {
      // Retrieve user document from Firestore
      DocumentSnapshot userDoc =
          await _firestore.collection('users').doc(user.uid).get();

      // Check if the document exists
      if (userDoc.exists) {
        return UserModel(
          id: userDoc['id'],
          name: userDoc['name'],
          contact: userDoc['contact'],
          gender: userDoc['gender'],
          points: userDoc['points'],
          wallet: userDoc['wallet'],
          profileImageUrl: userDoc['profileImageUrl'],
          dob: userDoc['dob'],
          lang: userDoc['lang'] ?? "en",
          vehicle: _parseVehicles(userDoc['vehicle']),
          // Add other fields as needed
        );
      } else {
        return null;
      }
    }
    return null;
  }

  Future<String> getCurrentUserId() async {
    final user = FirebaseAuth.instance.currentUser;
    return user!.uid;
  }

  Future<void> addVehicle(Vehicle vehicle) async {
    try {
      User? user = _auth.currentUser;

      if (user != null) {
        DocumentSnapshot userDoc =
            await _firestore.collection('users').doc(user.uid).get();
        if (userDoc.exists) {
          // If 'vehicles' field exists, update it with the new vehicle, else create a new list
          List<dynamic>? existingVehicles = userDoc['vehicle'];

          if (existingVehicles != null) {
            existingVehicles.add(vehicle.toJson());
          } else {
            existingVehicles = [vehicle.toJson()];
          }

          // Update user document in Firestore with the updated vehicles list
          await _firestore.collection('users').doc(user.uid).update({
            'vehicle': existingVehicles,
          });
        }
      }
    } catch (e) {
      toast("Error adding vehicle");
    }
  }

  Future<void> updateWallet(num amount) async {
    try {
      User? user = _auth.currentUser;

      if (user != null) {
        DocumentSnapshot userDoc =
            await _firestore.collection('users').doc(user.uid).get();
        if (userDoc.exists) {
          await _firestore.collection('users').doc(user.uid).update({
            'wallet': amount,
          });
        }
      }
    } catch (e) {
      toast("Error updating wallet");
      // Handle error
    }
  }

  Future<void> deleteVehicle(List<Vehicle>? vehicle) async {
    try {
      User? user = _auth.currentUser;

      if (user != null) {
        DocumentSnapshot userDoc =
            await _firestore.collection('users').doc(user.uid).get();
        if (userDoc.exists) {
          await _firestore.collection('users').doc(user.uid).update({
            'vehicle':
                userData?.vehicle?.map((vehicle) => vehicle.toJson()).toList(),
          });
        }
      }
    } catch (e) {
      toast("Vehicle deleted");
      print(e.toString());
      // Handle error
    }
  }

  Future<PromoCodes?> getPromoCodes() async {
    User? user = _auth.currentUser;

    if (user != null) {
      // Retrieve user document from Firestore
      DocumentSnapshot userDoc =
          await _firestore.collection('subscriptions').doc("promo_codes").get();

      // Check if the document exists
      if (userDoc.exists) {
        var docs = json.encode(userDoc.data());
        return PromoCodes.fromJson(json.decode(docs));
      }
    } else {
      return null;
    }
    return null;
  }

  Timestamp add12HoursToTimestamp(Timestamp originalTimestamp) {
    DateTime originalDateTime = originalTimestamp.toDate();
    DateTime newDateTime = originalDateTime.add(const Duration(hours: 24));
    Timestamp newTimestamp = Timestamp.fromDate(newDateTime);
    return newTimestamp;
  }

  Future<void> addSavedLocation(
      String userId, SavedLocation savedLocation) async {
    final userRef =
        FirebaseFirestore.instance.collection('saved_location').doc(userId);

    final doc = await userRef.get();
    List<dynamic> savedLocations =
        doc.exists ? doc.data()!['locations'] ?? [] : [];
    savedLocations.add(savedLocation.toMap());

    await userRef.set({'locations': savedLocations}, SetOptions(merge: true));
  }

  Future createBookings(BookingModel booking, bool saveLocation) async {
    CollectionReference bookingsCollection = _firestore.collection('bookings');

    if (saveLocation) {
      addSavedLocation(
          userData?.id ?? "",
          SavedLocation(
              address: booking.address.toString(),
              latitude: booking.latlong.lat,
              longitude: booking.latlong.long));
    }

    if (userData != null && (userData?.id != null)) {
      // 1. Create a new document reference and get its auto-generated ID:
      DocumentReference newBookingRef = bookingsCollection.doc();
      String bookingId = newBookingRef.id;

      // 2. Update the booking model with the ID:
      booking.bookingID =
          bookingId; // Assuming you have bookingID in your BookingModel

      // 3. Add the booking data to Firestore using the document reference:
      await newBookingRef
          .set(booking.toJson()); // Or however you convert to Map
    }
  }

  Future getBookingData() async {
    final userId = await getCurrentUserId();
    final query = FirebaseFirestore.instance
        .collection('bookings')
        .where('user_id', isEqualTo: userId);
    final snapshots = await query.get();
    final data = snapshots.docs.map((doc) => doc.data()).toList();
    log("my Booking data $data");
    return data;
  }

  Future<void> getAllPackagesFromFirestore() async {
    try {
      QuerySnapshot userSnapshot =
          await _firestore.collection('subscriptions').get();
      List<Package> packages = [];
      // log("= >>> subs data $userSnapshot");
      for (QueryDocumentSnapshot userDoc in userSnapshot.docs) {
        if (userDoc.exists) {
          Package package = Package(
              id: userDoc['id'],
              name: userDoc['name'],
              cost: userDoc['cost'],
              noOfWash: userDoc['noOfWash'],
              addService: userDoc['addService'],
              package: userDoc['package'],
              // removeService: userDoc['removeService'],
              dueration: userDoc['dueration'],

              // offerService: userDoc['offerService'],
              notes: userDoc['notes']);

          packages.add(package);
        }
      }

      subscriptionPackage = packages;
    } catch (e) {
      print('Error fetching packages: $e');
    }
  }

  Future<List<OfferServiceModel>> getServiceOffer() async {
    QuerySnapshot userSnapshot =
        await _firestore.collection('offer_service').get();

    List<OfferServiceModel> offerList = [];

    for (QueryDocumentSnapshot userDoc in userSnapshot.docs) {
      if (userDoc.exists) {
        OfferServiceModel offerServiceModel = OfferServiceModel(
          id: userDoc['id'],
          serviceName: userDoc['serviceName'] as String,
          serviceCost: userDoc['serviceCost'] as String,
        );

        offerList.add(offerServiceModel);
      }
    }
    log("----------$offerList");
    return offerList;
  }

  Future<List<PackageNameModel>> fetchPackages() async {
    var packageCollection = _firestore.collection('package');

    QuerySnapshot querySnapshot = await packageCollection.get();
    List<PackageNameModel> packages = querySnapshot.docs.map((doc) {
      log(doc.data());
      return PackageNameModel.fromMap(
          doc.id, doc.data() as Map<String, dynamic>);
    }).toList();

    return packages;
  }

  Future<List<ShiftModel>> fetchTimeSlot() async {
    var packageCollection = _firestore.collection('shift');

    QuerySnapshot querySnapshot = await packageCollection.get();
    List<ShiftModel> shift = querySnapshot.docs.map((doc) {
      log(doc.data());
      return ShiftModel.fromMap(doc.id, doc.data() as Map<String, dynamic>);
    }).toList();

    return shift;
  }

  Future<void> getVehicles() async {
    carBrands = [];
    carModels = {};
    try {
      final CollectionReference vehicleCollection =
          FirebaseFirestore.instance.collection('vehicles');
      DocumentSnapshot vehicleListDoc =
          await vehicleCollection.doc('vehicle_list').get();

      // Extract car brands and models from the "vehicle_list" document
      Map<String, dynamic>? data =
          vehicleListDoc.data() as Map<String, dynamic>?;

      if (data != null) {
        data.forEach((brand, models) {
          carBrands.add(brand);
          carModels[brand] = List<String>.from(models);
        });
      }
    } catch (e) {}
  }

  List<EmployeeModel> employeeList = [];
  Future<List<EmployeeModel>> getEmployee() async {
    QuerySnapshot userSnapshot = await _firestore.collection('Employee').get();

    for (QueryDocumentSnapshot userDoc in userSnapshot.docs) {
      if (userDoc.exists) {
        Map<String, dynamic>? shiftData = userDoc['shift'];
        String startTime =
            shiftData != null && shiftData.containsKey('startTime')
                ? shiftData['startTime']
                : '';
        String endTime = shiftData != null && shiftData.containsKey('endTime')
            ? shiftData['endTime']
            : '';

        EmployeeModel locations = EmployeeModel(
          id: userDoc['id'] ?? '',
          name: userDoc['name'] ?? "",
          phone: userDoc['phone'] ?? "",
          email: userDoc['email'] ?? "",
          company: userDoc['company'] ?? "",
          password: userDoc['password'] ?? "",
          salary: userDoc['salary'] ?? "",
          shift: "$startTime AM TO $endTime PM",
        );

        employeeList.add(locations);
      }
    }

    // log("-employeeList---------${employeeList[0].phone}");
    return employeeList;
  }
}
