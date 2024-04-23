import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:wype_user/auth/verify_otp.dart';
import 'package:wype_user/constants.dart';
import 'package:wype_user/model/add_service_model.dart';
import 'package:wype_user/model/booking.dart';
import 'package:wype_user/model/user_model.dart';

import '../home/root.dart';
import '../model/promo_code_model.dart';
import '../model/saved_location_model.dart';

class FirebaseService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

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
                  lang: lang,
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

  createBookings(BookingModel booking, bool saveLocation) async {
    CollectionReference bookingsCollection = _firestore.collection('bookings');

    if (saveLocation) {
      addSavedLocation(
          userData?.id ?? "",
          SavedLocation(
              address: booking.address,
              latitude: booking.latlong.lat,
              longitude: booking.latlong.long));
    }

    for (int i = 0; i < booking.washCount; i++) {
      if (i == 0) {
        bookingsCollection.add(booking.toJson());
      } else if (i > 0) {
        booking.washTimings = add12HoursToTimestamp(booking.washTimings);
        if (userData != null && (userData?.id != null)) {
          await bookingsCollection.add(booking.toJson());
        }
      } else {
        toast("Please try again later");
      }
    }
  }
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
    Map<String, dynamic>? data = vehicleListDoc.data() as Map<String, dynamic>?;

    if (data != null) {
      data.forEach((brand, models) {
        carBrands.add(brand);
        carModels[brand] = List<String>.from(models);
      });
    }
  } catch (e) {}
}

Future<List<Package>> getPackages() async {
  try {
    DocumentSnapshot<Map<String, dynamic>> packagesSnapshot =
        await FirebaseFirestore.instance
            .collection('offer_service')
            .doc('offers')
            .get();

    if (!packagesSnapshot.exists) {
      return [];
    }

    List<Package> packages = packagesSnapshot
        .data()!['packages']
        .map<Package>((package) => Package.fromJson(package))
        .toList();

    return packages;
  } catch (e) {
    print('Error getting packages: $e');
    return [];
  }
}

Future<void> getAllPackagesFromFirestore() async {
  try {
    DocumentSnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
        .instance
        .collection('subscriptions')
        .doc(
            '2QC6b6U6tBoZtf483ZU2') // Replace 'your_document_id' with the actual document ID
        .get();
    log("==>>${snapshot.data()}");
    if (!snapshot.exists) {
      // Document does not exist
    }

    Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;

    List<dynamic> packageDataList = data['packages'] ?? [];

    List<Package> packages = packageDataList
        .map((packageData) => Package.fromJson(packageData))
        .toList();

    subscriptionPackage = packages;
  } catch (e) {
    print('Error fetching packages: $e');
  }
}
