import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';
import 'package:wype_user/common/price_container.dart';
import 'package:wype_user/constants.dart';
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
    super.initState();
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
            GestureDetector(
              onTap: () {},
              child: ListView.separated(
                  shrinkWrap: true,
                  itemBuilder: (context, index) => GestureDetector(
                        onTap: () {
                          // ExtraServices(
                          //   saveLocation: widget.saveLocation,
                          //   promoCode: widget.promoCode,
                          //   coordinates: widget.coordinates,
                          //   address: widget.address,
                          //   selectedVehicleIndex: widget.selectedVehicleIndex,
                          //   selectedPackageIndex: 1,
                          // ).launch(context,
                          //     pageRouteAnimation: PageRouteAnimation.Fade);
                        },
                        child: PriceContainer(
                          onTap: () {
                            const WypePlusPlans().launch(context,
                                pageRouteAnimation: PageRouteAnimation.Fade);
                          },
                          title: 'Test',
                          subtitle: 'sns',
                          price: '1',
                          service: 'xx',
                        ),
                      ),
                  separatorBuilder: (context, index) => const SizedBox(
                        height: 20,
                      ),
                  itemCount: 2),
            ),
            // subscriptionPackage.isNotEmpty
            // ListView.builder(
            //     shrinkWrap: true,
            //     itemCount: subscriptionPackage.length ?? 0,
            //     itemBuilder: (_, index) {
            //       print("=>>${subscriptionPackage.length}");
            //       return Padding(
            //         padding: const EdgeInsets.only(bottom: 15.0),
            //         child: InkWell(
            //           borderRadius: BorderRadius.circular(20),
            //           onTap: () => ExtraServices(
            //             saveLocation: widget.saveLocation,
            //             promoCode: widget.promoCode,
            //             coordinates: widget.coordinates,
            //             address: widget.address,
            //             selectedVehicleIndex: widget.selectedVehicleIndex,
            //             selectedPackageIndex: index,
            //           ).launch(context,
            //               pageRouteAnimation: PageRouteAnimation.Fade),
            //           child: PriceContainer(

            //             title: subscriptionPackage[index].name ?? "N/A",
            //             subtitle: subscriptionPackage[index].about ?? "N/A",
            //             price: subscriptionPackage[index]
            //                     .pricing
            //                     .entries
            //                     .first
            //                     .value
            //                     .toString() ??
            //                 "N/A",
            //           ),
            //         ),
            //       );
            //     })

            //  const Center(child: CircularProgressIndicator.adaptive())
          ],
        ),
      ),
    );
  }
}
