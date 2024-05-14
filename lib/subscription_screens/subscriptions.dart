import 'package:animate_do/animate_do.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';
import 'package:wype_user/common/appbar.dart';

import 'package:wype_user/constants.dart';
import 'package:wype_user/model/add_service_model.dart';

import 'package:wype_user/model/promo_code_model.dart';
import 'package:wype_user/provider/language.dart';
import 'package:wype_user/services/firebase_services.dart';

import 'wype_plus_screen.dart';

class SubscriptionPage extends StatefulWidget {
  LatLng coordinates;
  String address;
  String? carName;
  String? carModel;

  int selectedVehicleIndex;
  Services? promoCode;
  bool saveLocation;

  SubscriptionPage(
      {super.key,
      required this.coordinates,
      required this.address,
      required this.selectedVehicleIndex,
      required this.saveLocation,
      this.carName,
      this.carModel,
      this.promoCode});

  @override
  State<SubscriptionPage> createState() => _SubscriptionPageState();
}

class _SubscriptionPageState extends State<SubscriptionPage> {
  @override
  @override
  void initState() {
    getAllPackagesFromFirestore();
    getServiceOffer();

    // getServiceOffer();
    super.initState();
  }

  var offerData;
  List<ServiceModel> serviceOffers = [];
  // Future<void> fetchOfferData() async {
  //   ServiceModel? offerData = await getServiceOffer();
  //   if (offerData != null) {
  //     setState(() {
  //       // Important for updating the UI
  //       serviceOffers.add(offerData);
  //     });
  //   }
  // }

  List offerList = [
    "Full Exterior Wash",
    "Tire & Dashboard Polish",
    "Rim Cleaning",
    "Interior Vacuuming",
    "Interior Glass Deep Clean",
    "Sanitization & Air Freshener"
  ];

  // List<Package> filteredSubscriptionPackage =
  //     subscriptionPackage.where((item) => item.package == null).toList();
  @override
  Widget build(BuildContext context) {
    var userLang = Provider.of<UserLang>(context, listen: true);
    log(widget.address);
    log(widget.coordinates);
    log(" car Name ${widget.carName}");
    log(" car Model ${widget.carModel}");

    return Scaffold(
      appBar: commonAppbar(userLang.isAr ? "الاشتراك" : "Subscription"),
      backgroundColor: whiteColor,
      body: FadeIn(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          shrinkWrap: true,
          physics: const BouncingScrollPhysics(),
          children: [
            10.height,
            ListView.separated(
              physics: const ScrollPhysics(),
              shrinkWrap: true,
              itemCount: subscriptionPackage.length,
              itemBuilder: (context, index) {
                var sub = subscriptionPackage[index];

                return Container(
                  padding: const EdgeInsets.all(0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: darkGradient),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(
                              10,
                            ),
                            topRight: Radius.circular(
                              10,
                            ),
                          ),
                          color: Color.fromRGBO(28, 32, 52, 1),
                        ),
                        width: double.infinity,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                sub.name ?? 'No Plan',
                                style: myFont28_600.copyWith(color: whiteColor),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                'Monthly Plans Available',
                                style: myFont500.copyWith(
                                    color:
                                        const Color.fromRGBO(255, 255, 255, 1)),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                  color: white,
                                  // height: 200,
                                  width: 200,
                                  child: ListView.builder(
                                    shrinkWrap: true,
                                    itemCount: offerList.length,
                                    itemBuilder: (context, index) =>
                                        Text(offerList[index]),
                                  )
                                  // ListView.builder(
                                  //   shrinkWrap: true,
                                  //   itemCount: serviceOffers.length,
                                  //   itemBuilder: (context, offerIndex) {
                                  //     var serviceOffer =
                                  //         serviceOffers[offerIndex];
                                  //     log("${serviceOffer.air}" ?? 'no');
                                  //     return Column(
                                  //       crossAxisAlignment:
                                  //           CrossAxisAlignment.start,
                                  //       children: [
                                  //         Text(
                                  //           "Full Exterior Wash ",
                                  //           style:
                                  //               myFont500.copyWith(color: black),
                                  //         ),
                                  //         Text(
                                  //           "Tire & Dashboard Polish ",
                                  //           style:
                                  //               myFont500.copyWith(color: black),
                                  //         ),
                                  //         Text(
                                  //           "Rim Cleaning ",
                                  //           style:
                                  //               myFont500.copyWith(color: black),
                                  //         ),
                                  //         Text(
                                  //           "Interior Vacuming ",
                                  //           style:
                                  //               myFont500.copyWith(color: black),
                                  //         ),
                                  //         Text(
                                  //           "Interior Glass Deep Clean ",
                                  //           style:
                                  //               myFont500.copyWith(color: black),
                                  //         ),
                                  //         Text(
                                  //           "Sanitization & Air Freshener ",
                                  //           style:
                                  //               myFont500.copyWith(color: black),
                                  //         ),
                                  //       ],
                                  //     );
                                  //   },
                                  // ),

                                  )),
                          const Spacer(),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: [
                                Text(sub.noOfWash == '1'
                                    ? 'One Wash'
                                    : sub.noOfWash),
                                Row(
                                  children: [
                                    Text(
                                      sub.cost == '1'
                                          ? 'one wash'
                                          : sub.cost ?? '0',
                                      style: myFont28_600.copyWith(
                                          fontSize: 28,
                                          color: Utils().blueDark),
                                    ),
                                    Text(
                                      " QAR",
                                      style: myFont28_600.copyWith(
                                          color: Utils().blueDark,
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ],
                                ),
                                TextButton(
                                    style: TextButton.styleFrom(
                                        backgroundColor: Utils().lightBlue),
                                    onPressed: () {
                                      List<String> services = [];
                                      for (var serviceOffer in serviceOffers) {
                                        services.add(serviceOffer
                                            .toString()); // Here, you can add the specific data from the service offer to the list
                                      }
                                      WypePlusPlans(
                                        servicePrices: services,
                                        services: const [],
                                        washType: sub.noOfWash ?? '1',
                                        subscriptionName: sub.name!,
                                        selectedSubscriptionPackageIndex: 0,
                                        carName: widget.carName,
                                        carModel: widget.carModel,
                                        address: widget.address,
                                        selectedVehicleIndex:
                                            widget.selectedVehicleIndex,
                                        cost: sub.cost ?? '0',
                                      ).launch(context,
                                          pageRouteAnimation:
                                              PageRouteAnimation.Fade);
                                      log(
                                        "=>>>>>>>${widget.address},${widget.selectedVehicleIndex},${sub.cost}",
                                      );
                                    },
                                    child: Text(
                                      'Book Now'.toUpperCase(),
                                      style:
                                          myFont28_600.copyWith(color: white),
                                    ))
                              ],
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                );
              },
              separatorBuilder: (BuildContext context, int index) => 10.height,
            ),
          ],
        ),
      ),
    );
  }
}
