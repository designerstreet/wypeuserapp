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
import 'package:wype_user/model/promo_code_model.dart';
import 'package:wype_user/onBoarding/add_vehicle.dart';
import 'package:wype_user/provider/language.dart';
import 'package:wype_user/services/firebase_services.dart';
import '../common/primary_button.dart';
import '../constants.dart';
import '../model/saved_location_model.dart';

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
    return showGeneralDialog(
        barrierLabel: "Label",
        barrierDismissible: true,
        barrierColor: Colors.black.withOpacity(0.5),
        transitionDuration: const Duration(milliseconds: 200),
        context: context,
        pageBuilder: (context, anim1, anim2) {
          return StatefulBuilder(builder: (context, StateSetter sheetState) {
            return Padding(
              padding: EdgeInsets.only(top: height(context) * 0.35),
              child: Material(
                child: SearchMapPlaceWidget(
                  onSelected: (place) {
                    place.geolocation.then((value) => {
                          Navigator.of(context).pop(),
                          onTapMap(value!.coordinates,
                              "${value.fullJSON['formatted_address']}"),
                        });
                  },
                  iconColor: Colors.grey,
                  textColor: Colors.black87,
                  placeType: PlaceType.address,
                  bgColor: Colors.white,
                  apiKey: "AIzaSyAOWj2nWK9JyDR8KocMHj6n5dsa8Fh38Ig",
                ),
              ),
            );
          });
        });
  }

  @override
  Widget build(BuildContext context) {
    var userLang = Provider.of<UserLang>(context, listen: true);
    FirebaseService firestoreService = FirebaseService();

    return Scaffold(
      backgroundColor: white,
      body: Column(
        children: [
          SizedBox(
            height: height(context) * 0.06,
          ),
          Padding(
            padding: const EdgeInsets.only(right: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 15.0),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(30),
                    onTap: () => popNav(context),
                    child: Icon(
                      Icons.chevron_left,
                      size: 30,
                      color: darkGradient,
                    ),
                  ),
                ),
                Text(
                  userLang.isAr ? "اضف عنوان" : "Add Address",
                  style: GoogleFonts.readexPro(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: widget.isFromHome ? darkGradient : darkGradient),
                ),
                InkWell(
                  borderRadius: BorderRadius.circular(30),
                  onTap: () => showLocationSelector(),
                  child: Icon(
                    Icons.search,
                    size: 30,
                    color: darkGradient,
                  ),
                ),
              ],
            ),
          ),
          20.height,
          Stack(
            children: [
              SizedBox(
                height: height(context) * 0.45,
                width: width(context),
                child: GoogleMap(
                  zoomControlsEnabled: true,
                  initialCameraPosition: CameraPosition(
                    target: currentCoordinates ?? const LatLng(48.8561, 2.2930),
                    zoom: 12.0,
                  ),
                  onMapCreated: (GoogleMapController controller) {
                    _controller = controller;
                  },
                  onTap: (position) => onTapMap(position, null),
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
          20.height,
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                userLang.isAr ? "حدد موقعك" : "Select your location",
                textAlign: TextAlign.center,
                style: GoogleFonts.readexPro(
                  color: darkGradient,
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          25.height,
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  InkWell(
                    splashColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    onTap: () {
                      if (currentAddress != null) {
                        AddVehiclePage(
                          saveLocation: true,
                          promoCode: widget.promoCode,
                          isFromHome: false,
                          coordinates: currentCoordinates,
                          address:
                              "${currentAddress!.name}, ${currentAddress!.administrativeArea}\n${currentAddress!.country}, ${currentAddress!.postalCode}",
                        ).launch(context,
                            pageRouteAnimation: PageRouteAnimation.Fade);
                      }
                    },
                    child: Column(children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(
                              FontAwesomeIcons.locationDot,
                              color: lightGradient,
                            ),
                            Text(
                              userLang.isAr
                                  ? "  الموقع من الخريطة"
                                  : "  Location from map",
                              textAlign: TextAlign.center,
                              style: GoogleFonts.readexPro(
                                color: lightGradient,
                                fontSize: 15,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            const Spacer(),
                            const Icon(
                              FontAwesomeIcons.chevronRight,
                              size: 18,
                            )
                          ],
                        ),
                      ),
                      10.height,
                      currentAddress == null
                          ? Container()
                          : Align(
                              alignment: Alignment.centerLeft,
                              child: Padding(
                                padding:
                                    const EdgeInsets.only(left: 20, top: 6),
                                child: Text(
                                  "${currentAddress!.name}, ${currentAddress!.administrativeArea}\n${currentAddress!.country}, ${currentAddress!.postalCode}",
                                  textAlign: TextAlign.left,
                                  style: GoogleFonts.readexPro(
                                    color: darkGradient,
                                    fontSize: 17,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ),
                            ),
                    ]),
                  ),
                  15.height,
                  Text(
                    userLang.isAr ? "أو" : "Or",
                    style:
                        GoogleFonts.readexPro(fontSize: 16, color: Colors.grey),
                  ),
                  15.height,
                  SizedBox(
                      height: height(context) * 0.17,
                      width: width(context),
                      child: StreamBuilder<List<SavedLocation>>(
                          stream: firestoreService
                              .getSavedLocations(userData?.id ?? ""),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const CircularProgressIndicator(
                                color: Colors.white,
                              ); // Show loading indicator while waiting for data
                            }
                            if (snapshot.hasError) {
                              return Text(
                                  'Error: ${snapshot.error}'); // Show error message if data fetching fails
                            }
                            List savedLocations = snapshot.data ??
                                []; // Retrieve saved locations from the snapshot
                            if (savedLocations.isEmpty) {
                              return Text(
                                "No Saved locations found",
                                textAlign: TextAlign.center,
                                style: GoogleFonts.readexPro(
                                    fontSize: 16, color: Colors.black),
                              );
                            }
                            return ListView.builder(
                              padding: const EdgeInsets.only(left: 15),
                              itemCount: savedLocations.length,
                              shrinkWrap: true,
                              scrollDirection: Axis.horizontal,
                              itemBuilder: (context, index) {
                                var location = savedLocations[index];
                                return InkWell(
                                  splashColor: Colors.transparent,
                                  highlightColor: Colors.transparent,
                                  onTap: () {
                                    AddVehiclePage(
                                      saveLocation: false,
                                      promoCode: widget.promoCode,
                                      isFromHome: false,
                                    ).launch(context,
                                        pageRouteAnimation:
                                            PageRouteAnimation.Fade);
                                  },
                                  child: Container(
                                    width: width(context) * 0.5,
                                    margin: const EdgeInsets.only(right: 10.0),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10.0),
                                      border: Border.all(color: Colors.grey),
                                    ),
                                    child: ListTile(
                                      title: Text(
                                        location.address,
                                        style: GoogleFonts.lato(
                                            color: Colors.black,
                                            fontWeight: FontWeight.w600),
                                      ),
                                      subtitle: Text(
                                        '${location.latitude}, ${location.longitude}',
                                        style: GoogleFonts.lato(
                                            color: Colors.black),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            );
                          })),
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
    );
  }
}
