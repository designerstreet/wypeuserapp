// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart' as location;
import 'package:nb_utils/nb_utils.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:search_map_place_updated/search_map_place_updated.dart';

import 'package:wype_user/common/appbar.dart';
import 'package:wype_user/common/login_filed.dart';
import 'package:wype_user/model/booking.dart';
import 'package:wype_user/model/promo_code_old.dart';
import 'package:wype_user/provider/language.dart';
import 'package:wype_user/services/firebase_services.dart';
import 'package:wype_user/services/location_services.dart';
import 'package:wype_user/subscription_screens/add_vehicle.dart';

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
  double? latitude;
  double? longitude;

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
                setState(() {
                  searchController.text =
                      "${value!.fullJSON['formatted_address']}";
                  selectedLocation = "${value.fullJSON['formatted_address']}";
                  latitude = value.coordinates.latitude;
                  longitude = value.coordinates.longitude;
                  searchController.clear();
                }),
                if (latitude != null && longitude != null)
                  {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MapLocation(
                          latLngModel: LatLngModel(
                              lat: latitude!.toDouble(),
                              long: longitude!.toDouble()),
                          address: selectedLocation == ''
                              ? "${currentAddress!.name}, ${currentAddress!.administrativeArea}\n${currentAddress!.country}, ${currentAddress!.postalCode}"
                              : selectedLocation,
                        ),
                      ),
                    )
                  }
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
                child: Column(children: [
                  InkWell(
                    splashColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    onTap: () {
                      if (latitude == null || longitude == null) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => MapLocation(
                              latLngModel: LatLngModel(
                                lat: currentCoordinates!.latitude.toDouble(),
                                long: currentCoordinates!.longitude,
                              ),
                              address: selectedLocation == ''
                                  ? "${currentAddress!.name}, ${currentAddress!.administrativeArea}\n${currentAddress!.country}, ${currentAddress!.postalCode}"
                                  : selectedLocation,
                            ),
                          ),
                        );
                      } else {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => MapLocation(
                              latLngModel: LatLngModel(
                                  lat: latitude!.toDouble(),
                                  long: longitude!.toDouble()),
                              address: selectedLocation == ''
                                  ? "${currentAddress!.name}, ${currentAddress!.administrativeArea}\n${currentAddress!.country}, ${currentAddress!.postalCode}"
                                  : selectedLocation,
                            ),
                          ),
                        );
                      }
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
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MapLocation extends StatefulWidget {
  LatLngModel? latLngModel;
  String? address;
  Services? promoCode;
  MapLocation({
    Key? key,
    this.latLngModel,
    this.address,
    this.promoCode,
  }) : super(key: key);

  @override
  State<MapLocation> createState() => _MapLocationState();
}

class _MapLocationState extends State<MapLocation> {
  location.Location currentLocation = location.Location();

  // LatLng? currentCoordinates;

  bool isFetching = true;
  GoogleMapController? _controller;
  LatLng? _selectedLocation;
  LatLng? _markerPosition;

  Set<Marker> _markers = {};

  //   _controller!.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
  //     target: LatLng(position.latitude, position.longitude),
  //     zoom: 12.0,
  //   )));
  //   currentCoordinates = LatLng(position.latitude, position.longitude);
  //   List<Placemark> placemarks =
  //       await placemarkFromCoordinates(position.latitude, position.longitude);
  //   currentAddress = placemarks[0];
  //   markers.clear();
  //   markers.add(Marker(
  //       markerId: const MarkerId('Tapped'),
  //       infoWindow: InfoWindow(title: currentAddress!.locality),
  //       position: LatLng(position.latitude, position.longitude)));
  //   setState(() {});
  // }

  @override
  void initState() {
    _selectedLocation =
        LatLng(widget.latLngModel!.lat, widget.latLngModel!.long);
    _markers.add(
      Marker(
        markerId: const MarkerId('selected-location'),
        position: _selectedLocation!,
      ),
    );
    super.initState();
  }

  void _onMapTapped(LatLng location) {
    setState(() {
      _selectedLocation = location;
      _markerPosition = location;
      _markers = {
        Marker(
          markerId: const MarkerId('selected-location'),
          position: _selectedLocation!,
        ),
      };
      _controller?.animateCamera(CameraUpdate.newLatLng(location));
    });
  }

  @override
  void dispose() {
    _controller?.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Set<Marker> markers = {
      Marker(
          markerId: const MarkerId('selected-location'),
          position: LatLng(widget.latLngModel!.lat, widget.latLngModel!.long)),
    };

    return Scaffold(
      appBar: commonAppbar('Confirm Address'),
      body: Column(
        children: [
          Expanded(
            child: GoogleMap(
              scrollGesturesEnabled: true,
              zoomControlsEnabled: true,
              zoomGesturesEnabled: true,
              trafficEnabled: true,
              mapToolbarEnabled: true,
              mapType: MapType.normal,
              myLocationEnabled: true,
              myLocationButtonEnabled: true,
              compassEnabled: true,
              initialCameraPosition: CameraPosition(
                target: _selectedLocation!,
                //  LatLng(widget.latLngModel?.lat ?? 19.13987,
                //     widget.latLngModel?.long ?? 72.8028716),
                zoom: 12.0,
              ),
              onMapCreated: (GoogleMapController controller) {
                _controller = controller;
              },
              markers: _markerPosition == null
                  ? markers
                  : {
                      Marker(
                        markerId: const MarkerId('my_marker'),
                        position: _markerPosition!,
                      ),
                    },
              onTap: _onMapTapped,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
            child: Row(
              children: [
                const FaIcon(
                  Icons.pin_drop_outlined,
                  size: 30,
                  color: skyBlue,
                ),
                Expanded(
                  child: Text(
                      "${_selectedLocation != null ? widget.address : "${_selectedLocation!.latitude} ${_selectedLocation!.longitude}"}",
                      textAlign: TextAlign.left,
                      style: myFont500.copyWith(fontWeight: FontWeight.w600)),
                ),
                const Spacer(),
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    'change'.toUpperCase(),
                    style: myFont28_600.copyWith(color: Utils().skyBlue),
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
                if (widget.address != null) {
                  AddVehiclePage(
                          saveLocation: true,
                          promoCode: widget.promoCode,
                          isFromHome: false,
                          coordinates: LatLng(widget.latLngModel!.lat,
                              widget.latLngModel!.long),
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
    );
  }
}
