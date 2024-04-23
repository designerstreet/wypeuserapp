import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:location/location.dart' as location;

GoogleMapController? _controller;
location.Location currentLocation = location.Location();

var loc;
Set<Marker> markers = {};
LatLng? currentCoordinates;
Placemark? currentAddress;
bool isFetching = true;

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

    // if (mounted) {
    //   isFetching = false;
    //   setState(() {});
    // }
  } catch (e) {
    isFetching = false;
    // setState(() {});
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
  // setState(() {});
}
// class LocationService extends StatefulWidget {
//   const LocationService({super.key});

//   @override
//   State<LocationService> createState() => LocationServiceState();
// }

// class LocationServiceState extends State<LocationService> {


//   @override
//   Widget build(BuildContext context) {
//     return const Placeholder();
//   }
// }
