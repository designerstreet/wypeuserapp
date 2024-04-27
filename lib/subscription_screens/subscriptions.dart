import 'package:animate_do/animate_do.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';
import 'package:wype_user/common/price_container.dart';
import 'package:wype_user/constants.dart';
import 'package:wype_user/model/add_service_model.dart';
import 'package:wype_user/model/promo_code_model.dart';
import 'package:wype_user/provider/language.dart';
import 'package:wype_user/services/firebase_services.dart';

import 'extra_services.dart';

class SubscriptionPage extends StatefulWidget {
  LatLng coordinates;
  String address;
  int selectedVehicleIndex;
  Services? promoCode;
  bool saveLocation;

  SubscriptionPage(
      {super.key,
      required this.coordinates,
      required this.address,
      required this.selectedVehicleIndex,
      required this.saveLocation,
      this.promoCode});

  @override
  State<SubscriptionPage> createState() => _SubscriptionPageState();
}

class _SubscriptionPageState extends State<SubscriptionPage> {
  @override
  @override
  void initState() {
    getAllPackagesFromFirestore();
    getOfferData();
    fetchOfferData();
    // getServiceOffer();
    super.initState();
  }

  List<ServiceModel> serviceOffers = [];
  Future<void> fetchOfferData() async {
    ServiceModel? offerData = await getOfferData();
    if (offerData != null) {
      setState(() {
        // Important for updating the UI
        serviceOffers.add(offerData);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var userLang = Provider.of<UserLang>(context, listen: true);

    return Scaffold(
      backgroundColor: whiteColor,
      body: FadeIn(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          shrinkWrap: true,
          physics: const BouncingScrollPhysics(),
          children: [
            SizedBox(
              height: height(context) * 0.07,
            ),
            Row(
              children: [
                InkWell(
                  borderRadius: BorderRadius.circular(20),
                  onTap: () => popNav(context),
                  child: const Icon(
                    Icons.chevron_left,
                    size: 29,
                  ),
                ),
                10.width,
                Text(userLang.isAr ? "الاشتراك" : "Subscription",
                    style: myFont28_600),
              ],
            ),
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
                                  itemCount: serviceOffers.length,
                                  itemBuilder: (context, index) {
                                    final serviceOffer = serviceOffers[index];
                                    log(serviceOffer.air ?? 'no');
                                    return Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          serviceOffer.air ?? 'no',
                                          style:
                                              myFont500.copyWith(color: black),
                                        ),
                                      ],
                                    );
                                  },
                                ),
                              )),
                          const Spacer(),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: [
                                const Text('One wash'),
                                Row(
                                  children: [
                                    Text(
                                      sub.cost ?? '0',
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
                                    onPressed: () {},
                                    child: Text(
                                      'Book Now'.toUpperCase(),
                                      style:
                                          myFont28_600.copyWith(color: white),
                                    )),
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
