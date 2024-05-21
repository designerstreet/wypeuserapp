import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:search_map_place_updated/search_map_place_updated.dart';
import 'package:location/location.dart' as location;
import 'package:wype_user/common/appbar.dart';
import 'package:wype_user/common/login_filed.dart';
import 'package:wype_user/model/promo_code_model.dart';
import 'package:wype_user/subscription_screens/add_vehicle.dart';
import 'package:wype_user/provider/language.dart';
import 'package:wype_user/services/firebase_services.dart';
import 'package:wype_user/services/location_services.dart';
import '../common/primary_button.dart';
import '../constants.dart';

class AddAddressPage extends StatefulWidget {
  bool isFromHome;
  Services? promoCode;
  AddAddressPage({super.key, required this.isFromHome, this.promoCode});

  @override
  State<AddAddressPage> createState() => _AddAddressPageState();
}

class _AddAddressPageState extends State<AddAddressPage> {
  GoogleMapController? _controller;
  location.Location currentLocation = location.Location();
  Set<Marker> markers = {};
  LatLng? currentCoordinates;
  Placemark? currentAddress;
  bool isFetching = true;
  var loc;
  TextEditingController searchController = TextEditingController();
  String selectedLocation = '';
  addLocation() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Padding(
            padding: EdgeInsets.symmetric(
                vertical:
                    (WidgetsBinding.instance.window.viewInsets.bottom > 0.0)
                        ? 0
                        : height(context) * 0.25),
            child: Dialog(
              elevation: 2,
              backgroundColor: Colors.white,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.white,
                ),
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Align(
                      alignment: Alignment.center,
                      child: Text(
                        "Enter Address",
                        style: GoogleFonts.readexPro(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: darkGradient),
                      ),
                    ),
                    20.height,
                    AppTextField(
                      textStyle: GoogleFonts.readexPro(),
                      textFieldType: TextFieldType.MULTILINE,
                      maxLines: 4,
                      decoration: inputDecoration(context,
                          labelText: "John Doe Apartments"),
                    ),
                    30.height,
                    Align(
                      alignment: Alignment.center,
                      child: PrimaryButton(
                        text: "Continue",
                        onTap: () {
                          AddVehiclePage(
                            saveLocation: true,
                            promoCode: widget.promoCode,
                            isFromHome: false,
                          ).launch(context,
                              pageRouteAnimation: PageRouteAnimation.Fade);
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }

  void getLocation() async {
    try {
      toast("Fetching current location");
      await currentLocation.requestPermission();
      [
        Permission.location,
      ].request();

      await currentLocation.getLocation().then((value) => {
            loc = value,
            _controller
                ?.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
              target: LatLng(value.latitude ?? 0.0, value.longitude ?? 0.0),
              zoom: 12.0,
            )))
          });

      currentCoordinates = LatLng(loc.latitude!, loc.longitude!);
      List<Placemark> placemarks = await placemarkFromCoordinates(
          currentCoordinates!.latitude, currentCoordinates!.longitude);
      currentAddress = placemarks[0];
      markers.add(Marker(
          markerId: const MarkerId('Home'),
          infoWindow: InfoWindow(
            title: currentAddress!.street,
            snippet: currentAddress!.country,
          ),
          position: LatLng(loc.latitude ?? 0.0, loc.longitude ?? 0.0)));

      if (mounted) {
        isFetching = false;
        setState(() {});
      }
    } catch (e) {
      isFetching = false;
      setState(() {});
      toast("Something went wrong");
    }
  }

  onTapMap(LatLng position, String? address) async {
    _controller!.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
      target: LatLng(position.latitude, position.longitude),
      zoom: 12.0,
    )));
    currentCoordinates = LatLng(position.latitude, position.latitude);
    List<Placemark> placemarks =
        await placemarkFromCoordinates(position.latitude, position.longitude);
    currentAddress = placemarks[0];
    markers.clear();
    markers.add(Marker(
        markerId: const MarkerId('Tapped'),
        infoWindow: InfoWindow(title: currentAddress!.locality),
        position: LatLng(position.latitude, position.longitude)));
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    getLocation();
  }

  @override
  void dispose() {
    _controller?.dispose();
    markers.clear();
    super.dispose();
  }

  showLocationSelector() {
    return StatefulBuilder(builder: (context, StateSetter sheetState) {
      return Material(
        child: SearchMapPlaceWidget(
          apiKey: "AIzaSyAOWj2nWK9JyDR8KocMHj6n5dsa8Fh38Ig",
          onSelected: (place) {
            place.geolocation.then((value) {
              return {
                searchController.text =
                    "${value!.fullJSON['formatted_address']}",
                selectedLocation = "${value.fullJSON['formatted_address']}",
                setState(() {}),
                searchController.clear(),
              };
            });
          },
          iconColor: Colors.grey,
          textColor: Colors.black87,
          placeType: PlaceType.address,
          bgColor: Colors.white,
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    var userLang = Provider.of<UserLang>(context, listen: true);
    FirebaseService firestoreService = FirebaseService();

    return Scaffold(
      appBar: commonAppbar(
        userLang.isAr ? "اضف عنوان" : "Add Address / Change Address",
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
        child: Column(
          children: [
            // ),
            showLocationSelector(),

            25.height,
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    InkWell(
                      splashColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => MapLocation(
                                address: selectedLocation == ''
                                    ? "${currentAddress!.name}, ${currentAddress!.administrativeArea}\n${currentAddress!.country}, ${currentAddress!.postalCode}"
                                    : selectedLocation,
                              ),
                            ));
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            border: Border.all(color: gray),
                            borderRadius: BorderRadius.circular(8)),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 12),
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.gps_fixed,
                                      color: Utils().lightBlue,
                                    ),
                                    Text(
                                        userLang.isAr
                                            ? "  الموقع من الخريطة"
                                            : "  Use Current location",
                                        textAlign: TextAlign.center,
                                        style: myFont28_600.copyWith(
                                            color: Utils().lightBlue)),
                                    const Spacer(),
                                  ],
                                ),
                                const Divider(),
                                10.height,
                                Text(
                                  'Current address'.toUpperCase(),
                                  style: myFont500.copyWith(),
                                ),
                                currentAddress == null
                                    ? CircularProgressIndicator.adaptive(
                                        backgroundColor: Utils().lightBlue,
                                      )
                                    : Align(
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                            selectedLocation == ''
                                                ? "${currentAddress!.name}, ${currentAddress!.administrativeArea}\n${currentAddress!.country}, ${currentAddress!.postalCode}"
                                                : selectedLocation,
                                            textAlign: TextAlign.left,
                                            style: myFont500.copyWith(
                                                fontWeight: FontWeight.w600)),
                                      ),
                              ]),
                        ),
                      ),
                    ),
                    15.height,
                    // Text(
                    //   userLang.isAr ? "أو" : "Or",
                    //   style: GoogleFonts.readexPro(
                    //       fontSize: 16, color: Colors.grey),
                    // ),
                    15.height,
                    // SizedBox(
                    //     height: height(context) * 0.17,
                    //     width: width(context),
                    //     child: StreamBuilder<List<SavedLocation>>(
                    //         stream: firestoreService
                    //             .getSavedLocations(userData?.id ?? ""),
                    //         builder: (context, snapshot) {
                    //           if (snapshot.connectionState ==
                    //               ConnectionState.waiting) {
                    //             return const CircularProgressIndicator(
                    //               color: Colors.white,
                    //             ); // Show loading indicator while waiting for data
                    //           }
                    //           if (snapshot.hasError) {
                    //             return Text(
                    //                 'Error: ${snapshot.error}'); // Show error message if data fetching fails
                    //           }
                    //           List savedLocations = snapshot.data ??
                    //               []; // Retrieve saved locations from the snapshot
                    //           if (savedLocations.isEmpty) {
                    //             return Text(
                    //               "No Saved locations found",
                    //               textAlign: TextAlign.center,
                    //               style: GoogleFonts.readexPro(
                    //                   fontSize: 16, color: Colors.black),
                    //             );
                    //           }
                    //           return ListView.builder(
                    //             padding: const EdgeInsets.only(left: 15),
                    //             itemCount: savedLocations.length,
                    //             shrinkWrap: true,
                    //             scrollDirection: Axis.horizontal,
                    //             itemBuilder: (context, index) {
                    //               var location = savedLocations[index];
                    //               return InkWell(
                    //                 splashColor: Colors.transparent,
                    //                 highlightColor: Colors.transparent,
                    //                 onTap: () {
                    //                   AddVehiclePage(
                    //                     saveLocation: false,
                    //                     promoCode: widget.promoCode,
                    //                     isFromHome: false,
                    //                   ).launch(context,
                    //                       pageRouteAnimation:
                    //                           PageRouteAnimation.Fade);
                    //                 },
                    //                 child: Container(
                    //                   width: width(context) * 0.5,
                    //                   margin:
                    //                       const EdgeInsets.only(right: 10.0),
                    //                   decoration: BoxDecoration(
                    //                     borderRadius:
                    //                         BorderRadius.circular(10.0),
                    //                     border: Border.all(color: Colors.grey),
                    //                   ),
                    //                   child: ListTile(
                    //                     title: Text(
                    //                       location.address,
                    //                       style: GoogleFonts.lato(
                    //                           color: Colors.black,
                    //                           fontWeight: FontWeight.w600),
                    //                     ),
                    //                     subtitle: Text(
                    //                       '${location.latitude}, ${location.longitude}',
                    //                       style: GoogleFonts.lato(
                    //                           color: Colors.black),
                    //                     ),
                    //                   ),
                    //                 ),
                    //               );
                    //             },
                    //           );
                    //         })),

                    40.height,
                    // InkWell(
                    //   borderRadius: BorderRadius.circular(15),
                    //   onTap: () => showLocationSelector(),
                    //   child: Container(
                    //     padding:
                    //         EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    //     decoration: BoxDecoration(
                    //         border: Border.all(color: Colors.grey),
                    //         borderRadius: BorderRadius.circular(15)),
                    //     child: Text(
                    //       userLang.isAr ? "موقع البحث" : "Search location",
                    //       style: GoogleFonts.readexPro(fontSize: 16),
                    //     ),
                    //   ),
                    // ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MapLocation extends StatefulWidget {
  String? address;
  Services? promoCode;
  MapLocation({super.key, this.promoCode, this.address});

  @override
  State<MapLocation> createState() => _MapLocationState();
}

class _MapLocationState extends State<MapLocation> {
  location.Location currentLocation = location.Location();
  var loc;
  Set<Marker> markers = {};
  LatLng? currentCoordinates;
  Placemark? currentAddress;
  bool isFetching = true;
  GoogleMapController? _controller;
  void getLocation() async {
    try {
      toast("Fetching current location");
      await currentLocation.requestPermission();
      [
        Permission.location,
      ].request();

      await currentLocation.getLocation().then((value) => {
            loc = value,
            _controller
                ?.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
              target: LatLng(value.latitude ?? 0.0, value.longitude ?? 0.0),
              zoom: 12.0,
            )))
          });

      currentCoordinates = LatLng(loc.latitude!, loc.longitude!);
      List<Placemark> placemarks = await placemarkFromCoordinates(
          currentCoordinates!.latitude, currentCoordinates!.longitude);
      currentAddress = placemarks[0];
      markers.add(Marker(
          markerId: const MarkerId('Home'),
          infoWindow: InfoWindow(
            title: currentAddress!.street,
            snippet: currentAddress!.country,
          ),
          position: LatLng(loc.latitude ?? 0.0, loc.longitude ?? 0.0)));

      if (mounted) {
        isFetching = false;
        setState(() {});
      }
    } catch (e) {
      isFetching = false;
      setState(() {});
      toast("Something went wrong");
    }
  }

  onTapMap(LatLng position, String? address) async {
    _controller!.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
      target: LatLng(position.latitude, position.longitude),
      zoom: 12.0,
    )));
    currentCoordinates = LatLng(position.latitude, position.longitude);
    List<Placemark> placemarks =
        await placemarkFromCoordinates(position.latitude, position.longitude);
    currentAddress = placemarks[0];
    markers.clear();
    markers.add(Marker(
        markerId: const MarkerId('Tapped'),
        infoWindow: InfoWindow(title: currentAddress!.locality),
        position: LatLng(position.latitude, position.longitude)));
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    getLocation();
  }

  @override
  void dispose() {
    _controller?.dispose();
    markers.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: commonAppbar('Confirm Address'),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Stack(
                children: [
                  SizedBox(
                    height: height(context) * 0.80,
                    width: width(context),
                    child: GoogleMap(
                      zoomControlsEnabled: true,
                      initialCameraPosition: CameraPosition(
                        target:
                            currentCoordinates ?? const LatLng(48.8561, 2.2930),
                        zoom: 12.0,
                      ),
                      onMapCreated: (GoogleMapController controller) {
                        _controller = controller;
                      },
                      onTap: (position) => onTapMap(
                          currentCoordinates ?? const LatLng(48.8561, 2.2930),
                          ''),
                      markers: markers,
                    ),
                  ),
                  if (isFetching)
                    SizedBox(
                      height: height(context) * 0.45,
                      width: width(context),
                      child: Center(
                        child: CircularProgressIndicator(
                          color: darkGradient,
                        ),
                      ),
                    ),
                ],
              ),
              currentAddress == null
                  ? Container()
                  : Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 15, vertical: 15),
                      child: Row(
                        children: [
                          const FaIcon(
                            Icons.pin_drop_outlined,
                            size: 30,
                            color: skyBlue,
                          ),
                          Text("${widget.address}",
                              textAlign: TextAlign.left,
                              style: myFont500.copyWith(
                                  fontWeight: FontWeight.w600)),
                          const Spacer(),
                          GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Text(
                              'change'.toUpperCase(),
                              style:
                                  myFont28_600.copyWith(color: Utils().skyBlue),
                            ),
                          ),
                          Icon(
                            Icons.arrow_forward_ios,
                            color: Utils().skyBlue,
                            size: 18,
                          )
                        ],
                      ),
                    ),
              10.height,
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: PrimaryButton(
                  text: 'CONFIRM LOCATION',
                  onTap: () {
                    if (currentAddress != null) {
                      AddVehiclePage(
                              saveLocation: true,
                              promoCode: widget.promoCode,
                              isFromHome: false,
                              coordinates: currentCoordinates,
                              address: widget.address)
                          .launch(context,
                              pageRouteAnimation: PageRouteAnimation.Fade);
                    }
                  },
                ),
              ),
              20.height
            ],
          ),
        ),
      ),
    );
  }
}
