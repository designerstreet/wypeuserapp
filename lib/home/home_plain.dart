// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';

import 'package:wype_user/constants.dart';
import 'package:wype_user/services/firebase_services.dart';
import 'package:wype_user/subscription_screens/add_address.dart';
import 'package:wype_user/provider/language.dart';
import 'package:wype_user/services/location_services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

import '../common/home_row.dart';
import '../common/primary_button.dart';

class PlainHome extends StatefulWidget {
  const PlainHome({Key? key}) : super(key: key);

  @override
  State<PlainHome> createState() => _PlainHomeState();
}

class _PlainHomeState extends State<PlainHome> {
  FirebaseService firebaseService = FirebaseService();

  @override
  void initState() {
    // TODO: implement initState
    getCurrentLocation();
    AddAddressPage(isFromHome: true);
    getServiceOffer();
    super.initState();
  }

  String address = "Getting current location...";
  void getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;
    // Check if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      setState(() {
        address = 'Location services are disabled.';
      });
      return;
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        setState(() {
          address = 'Location permissions are denied';
        });
        return;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      setState(() {
        address =
            'Location permissions are permanently denied, we cannot request permissions.';
      });
      return;
    }
    // When we reach here, permissions are granted and we can continue accessing the position of the device.
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    getAddressFromLatLng(position);
  }

  void getAddressFromLatLng(Position position) async {
    try {
      List<Placemark> placemarks =
          await placemarkFromCoordinates(position.latitude, position.longitude);
      Placemark place = placemarks[0];
      setState(() {
        address = "${place.locality}, ${place.postalCode}, ${place.country}";
      });
    } catch (e) {
      print(e);
    }
  }

  List homeCar = [Image.asset('assets/images/homecar.png')];
  @override
  Widget build(BuildContext context) {
    var userLang = Provider.of<UserLang>(context, listen: true);

    Placemark? currentAddress;
    return SafeArea(
      child: Scaffold(
        backgroundColor: white,
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Row(
                  children: [
                    FaIcon(
                      Icons.pin_drop_outlined,
                      color: Utils().lightBlue,
                      size: 40,
                    ),
                    Column(
                      children: [Text(address)],
                    ),
                  ],
                ),
                const Divider(),
                20.height,
                Text(
                  "Welcome, ${userData?.name.capitalizeFirstLetter()}" ?? "",
                  style: myFont28_600.copyWith(
                      fontSize: 24, fontWeight: FontWeight.w600),
                ),
                25.height,
                CarouselSlider(
                  items: [
                    Container(
                      // height: 140,
                      width: double.infinity,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: Utils().blueDark,
                          image: const DecorationImage(
                              image: AssetImage(
                                'assets/images/homecar.png',
                              ),
                              alignment: Alignment.centerRight)),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Image.asset(
                              'assets/images/logo.png',
                              width: 44,
                            ),
                            Text(
                              'Subcriptions',
                              style: myFont28_600.copyWith(color: white),
                            ),
                            10.height,
                            Text(
                              'Plans starting from AD100',
                              style: myFont500.copyWith(
                                  color: white, fontSize: 11),
                            ),
                            10.height,
                            TextButton(
                                style: TextButton.styleFrom(
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(5)),
                                    foregroundColor: white,
                                    backgroundColor: const Color.fromRGBO(
                                        255, 255, 255, 0.1)),
                                onPressed: null,
                                child: Text(
                                  'Join Wype+',
                                  style: myFont500.copyWith(color: white),
                                ))
                          ],
                        ),
                      ),
                    ),
                  ],
                  options: CarouselOptions(
                    viewportFraction: 1,
                    // clipBehavior: Clip.hardEdge,

                    autoPlay: true, // Enable auto-play
                    enlargeCenterPage:
                        true, // Increase the size of the center item
                    enableInfiniteScroll: true, // Enable infinite scroll
                    onPageChanged: (index, reason) {},
                  ),
                ),
                41.height,
                HomeRow(
                  fullwash: () {
                    log('full wahs');
                  },
                  polish: () {},
                  rim: () {},
                  title: 'Full Exterior Wash',
                  subTitle: 'Tire &\nDashboard Polish',
                  subText: 'Rim Cleaning',
                  titleImage: 'assets/images/fullwash.png',
                  subImage: 'assets/images/polish.png',
                  subTextImage: 'assets/images/rim.png',
                ),
                40.height,
                HomeRow(
                  fullwash: () {
                    log('vacuming');
                  },
                  polish: () {},
                  rim: () {},
                  title: 'Interior Vaccuming',
                  subTitle: 'Interior Glass Deep Clean',
                  subText: 'Sanitization & Air Freshener',
                  titleImage: 'assets/images/vacuming.png',
                  subImage: 'assets/images/deepclean.png',
                  subTextImage: 'assets/images/air.png',
                ),
                40.height,
                Align(
                  alignment: Alignment.center,
                  child: PrimaryButton(
                      text: userLang.isAr ? "عدم السماح" : "Book Now",
                      onTap: () => navigation(
                          context,
                          AddAddressPage(
                            isFromHome: true,
                          ),
                          true)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
