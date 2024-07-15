import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
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
import 'package:wype_user/payment/payment_success_screen.dart';

import '../home/root.dart';
import '../model/promo_code.dart';
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
          Get.offAll(const RootPage());
        }
      }
    } else {
      Get.offAll(const RootPage());
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

  Future<bool> updateWallet(num amountToAdd) async {
    try {
      User? user = _auth.currentUser;
      if (user != null) {
        DocumentReference userDocRef =
            _firestore.collection('users').doc(user.uid);

        bool result = await _firestore.runTransaction((transaction) async {
          DocumentSnapshot userDoc = await transaction.get(userDocRef);

          String status = 'success'; // Default status is success

          if (userDoc.exists) {
            num currentBalance = userDoc['wallet'] ?? 0;

            // Check for insufficient funds (failure condition)
            if (currentBalance + amountToAdd < 0) {
              status = 'failed'; // Set status to failed
            } else {
              num newBalance = currentBalance + amountToAdd;
              transaction.update(userDocRef, {'wallet': newBalance});
            }
          } else {
            status = 'failed'; // Set status to failed if no document
          }

          // Create history entry regardless of success or failure
          Map<String, dynamic> historyEntry = {
            'status': status,
            'date': DateTime.now(),
            'amount': amountToAdd,
          };

          // Update history
          transaction.update(userDocRef, {
            'wallet_history': FieldValue.arrayUnion([historyEntry])
          });

          return status ==
              'success'; // Transaction result is success or failure
        });

        return result;
      }
      return false;
    } catch (e) {
      log("Error updating wallet: $e");
      User? user = _auth.currentUser;
      // Add history entry for the error
      await _firestore.collection('users').doc(user!.uid).update({
        'history': FieldValue.arrayUnion([
          {
            'status': 'failed',
            'date': DateTime.now(),
            'amount': amountToAdd,
            'error': e.toString()
          }
        ])
      });

      return false;
    }
  }

  Future payWithWallet(num paymentAmount) async {
    try {
      User? user = _auth.currentUser;

      if (user != null) {
        DocumentSnapshot userDoc =
            await _firestore.collection('users').doc(user.uid).get();
        if (userDoc.exists) {
          num currentBalance = userDoc['wallet'] ?? 0;

          if (currentBalance >= paymentAmount) {
            num newBalance = currentBalance - paymentAmount;

            await _firestore.collection('users').doc(user.uid).update({
              'wallet': newBalance,
            });

            toast("Payment successful. New balance: $newBalance");
            Get.offAll(PaymentSuccessScreen(address: ''));
          } else {
            toast("Insufficient funds. Current balance: $currentBalance");
          }
        }
      }
    } catch (e) {
      toast("Error making payment");
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

  Future<List<PromoCodeModel>> getPromoCodes() async {
    // 1. Get the collection reference (no need to check the current user)
    CollectionReference promoCodeCollection =
        FirebaseFirestore.instance.collection('promo_code');

    // 2. Query the collection for all documents
    QuerySnapshot querySnapshot = await promoCodeCollection.get();

    // 3. Convert documents into PromoCodeModel objects
    List<PromoCodeModel> promoCodes = [];
    for (QueryDocumentSnapshot doc in querySnapshot.docs) {
      promoCodes.add(PromoCodeModel.fromDocument(doc));
    }

    return promoCodes;
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

  Future<void> updateBookingInFirebase(
    String bookingID,
    int slotID,
    // String carName,
    // String carNumber,
    // String modelNumber,
    // String subscriptionName,
    String time,
    String date,
  ) async {
    // Retrieve the document
    DocumentSnapshot bookingDoc = await FirebaseFirestore.instance
        .collection('bookings')
        .doc(bookingID)
        .get();

    if (bookingDoc.exists) {
      Map<String, dynamic> bookingData =
          bookingDoc.data() as Map<String, dynamic>;
      List<dynamic> slotDates = bookingData['slotDate'];

      // Find and update the correct slot based on slotID
      bool slotFound = false;
      for (var slotDate in slotDates) {
        if (slotDate['bookingID'] == slotID) {
          slotFound = true;
          if (slotDate['dates'] != null && slotDate['dates'].isNotEmpty) {
            slotDate['dates'][0] =
                Timestamp.fromDate(DateFormat('yyyy-MM-dd').parse(date));
          }
          if (slotDate['slot'] != null) {
            slotDate['slot']['startTime'] = time;
          }
          break;
        }
      }

      if (slotFound) {
        // Update the booking document with the modified data
        await FirebaseFirestore.instance
            .collection('bookings')
            .doc(bookingID)
            .update({
          // 'vehicle.company': carName,
          // 'vehicle.number_plate': carNumber,
          // 'vehicle.model': modelNumber,
          // 'subscriptionName': subscriptionName,
          'slotDate': slotDates,
        });
      } else {
        print('Slot with slotID $slotID not found.');
      }
    } else {
      print('Booking document with ID $bookingID not found.');
    }
  }

  Future closeBookingData() async {
    final userId = await getCurrentUserId();
    final query = FirebaseFirestore.instance
        .collection('closedBookings')
        .where('user_id', isEqualTo: userId);
    final snapshots = await query.get();
    final data = snapshots.docs.map((doc) => doc.data()).toList();
    log("my Booking data $data");
    return data;
  }

  Future updateBookingAddress(String bookingId, String newAddress) async {
    await FirebaseFirestore.instance
        .collection('bookings')
        .doc(bookingId)
        .update({'address': newAddress});
  }

  Future deleteBookingAddress(String bookingId) async {
    await _firestore.collection('bookings').doc(bookingId).delete();
  }

  Future<void> getAllPackagesFromFirestore() async {
    try {
      QuerySnapshot userSnapshot =
          await _firestore.collection('subscriptions').get();
      List<Package> packages = [];
      // log("= >>> subs data $userSnapshot");
      for (QueryDocumentSnapshot userDoc in userSnapshot.docs) {
        log(userDoc.data());
        if (userDoc.exists) {
          Package package = Package(
              id: userDoc['id'] ?? '',
              name: userDoc['name'] ?? '',
              cost: List.from(userDoc['cost'] ?? []),
              noOfWash: List.from(userDoc['noOfWash'] ?? []),
              addService: userDoc['addService'] ?? '',
              package: userDoc['package'] ?? '',
              description: userDoc['description'] ?? '',
              dueration: userDoc['dueration'] ?? '',
              offerService: userDoc['offerService'] ?? '',
              notes: userDoc['notes'] ?? '');
          log(package);
          packages.add(package);
        }
      }

      subscriptionPackage = packages;
    } catch (e) {
      log('Error fetching packages: $e');
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

  Future<void> updateProfile(
      String id, String name, String phone, String dob) async {
    try {
      User? user = _auth.currentUser;

      if (user != null) {
        DocumentSnapshot userDoc =
            await _firestore.collection('users').doc(user.uid).get();
        if (userDoc.exists) {
          await _firestore.collection('users').doc(user.uid).update({
            'name': name,
            'contact': phone,
            'dob': dob,
          });
        }
      }
    } catch (e) {
      toast("Error updating profile");
      // Handle error
    }
  }
}
