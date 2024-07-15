// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';

import 'package:wype_user/constants.dart';
import 'package:wype_user/onBoarding/add_address.dart';
import 'package:wype_user/provider/language.dart';

import '../common/home_row.dart';
import '../common/primary_button.dart';

class PlainHome extends StatefulWidget {
  const PlainHome({Key? key}) : super(key: key);

  @override
  State<PlainHome> createState() => _PlainHomeState();
}

class _PlainHomeState extends State<PlainHome> {
  @override
  void initState() {
    // TODO: implement initState
    AddAddressPage(isFromHome: true);
    super.initState();
  }

  List homeCar = [Image.asset('assets/images/homecar.png')];
  @override
  Widget build(BuildContext context) {
    var userLang = Provider.of<UserLang>(context, listen: true);
    LatLng? currentCoordinates;
    Placemark? currentAddress;
    return SafeArea(
      child: Scaffold(
        backgroundColor: white,
        body: SizedBox(
          width: width(context),
          height: height(context),
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
                      color: Utils().darkBlue,
                      size: 40,
                    ),
                    Column(
                      children: [
                        Text(
                          'Doha',
                          style: myFont28_600,
                        ),
                        const Text('data'),
                      ],
                    ),
                  ],
                ),
                // Text(
                //   "${currentAddress!.name}, ${currentAddress.administrativeArea}\n${currentAddress.country}, ${currentAddress.postalCode}" ??
                //       '',
                // ),
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
                                onPressed: () {},
                                child: const Text('Join Wype+'))
                          ],
                        ),
                      ),
                    ),
                  ],
                  options: CarouselOptions(
                    // height: height(context) *
                    //     0.2, // Customize the height of the carousel
                    autoPlay: true, // Enable auto-play
                    enlargeCenterPage:
                        true, // Increase the size of the center item
                    enableInfiniteScroll: true, // Enable infinite scroll
                    onPageChanged: (index, reason) {
                      // Optional callback when the page changes
                      // You can use it to update any additional UI components
                    },
                  ),
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
                41.height,
                HomeRow(
                  title: 'Full Exterior Wash',
                  subTitle: 'Tire &\nDashboard Polish',
                  subText: 'Rim Cleaning',
                  titleImage: 'assets/images/fullwash.png',
                  subImage: 'assets/images/polish.png',
                  subTextImage: 'assets/images/rim.png',
                ),
                40.height,
                HomeRow(
                  title: 'Interior Vaccuming',
                  subTitle: 'Interior Glass Deep Clean',
                  subText: 'Sanitization & Air Freshener',
                  titleImage: 'assets/images/vacuming.png',
                  subImage: 'assets/images/deepclean.png',
                  subTextImage: 'assets/images/air.png',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
