// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:animate_do/animate_do.dart';
import 'package:coupon_uikit/coupon_uikit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:wype_user/booking/booking_summary_screen.dart';

import 'package:wype_user/common/appbar.dart';
import 'package:wype_user/common/primary_button.dart';
import 'package:wype_user/constants.dart';
import 'package:wype_user/model/promo_code.dart';
import 'package:wype_user/services/firebase_services.dart';

class PromoCodeScreen extends StatefulWidget {
  var subCost;
  var noOfWash;
  String subscriptionName;
  LatLng coordinates;
  var serviceName;
  var serviceCost;
  String? carName;
  String? carModel;
  var selectedDate;
  String? address;
  int selectedVehicleIndex;
  int selectedPackageIndex;
  var slotDate;
  // int selectedSlotIndex;
  double price;
  String? washCount;

  String? packageName;
  PromoCodeScreen({
    Key? key,
    required this.subCost,
    required this.noOfWash,
    required this.subscriptionName,
    required this.coordinates,
    required this.serviceName,
    required this.serviceCost,
    this.carName,
    this.carModel,
    required this.selectedDate,
    this.address,
    required this.selectedVehicleIndex,
    required this.selectedPackageIndex,
    required this.slotDate,
    required this.price,
    this.washCount,
    this.packageName,
  }) : super(key: key);

  @override
  State<PromoCodeScreen> createState() => _PromoCodeScreenState();
}

class _PromoCodeScreenState extends State<PromoCodeScreen> {
  FirebaseService firebaseService = FirebaseService();
  List<PromoCodeModel> promoCodes = [];
  void fetchPromoCodes() async {
    promoCodes = await firebaseService.getPromoCodes();
    setState(() {}); // Update the UI after fetching
  }

  @override
  void initState() {
    super.initState();
    fetchPromoCodes();
  }

  @override
  Widget build(BuildContext context) {
    return FadeIn(
        child: Scaffold(
      appBar: commonAppbar('Promos & Offers'),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Column(
          children: [
            Expanded(
              child: ListView.separated(
                itemCount: promoCodes.length,
                shrinkWrap: true,
                separatorBuilder: (context, index) => const SizedBox(
                  height: 10,
                ),
                itemBuilder: (context, index) {
                  return CouponCard(
                    // height: 150,
                    backgroundColor: Utils().softBlue,
                    curveAxis: Axis.vertical,
                    firstChild: Container(
                      decoration: BoxDecoration(
                        color: Utils().lightBlue,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Center(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    "${promoCodes[index].discount.toString()}%",
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const Text(
                                    'OFF',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const Divider(color: Colors.white54, height: 0),
                          Expanded(
                            child: Center(
                              child: Text(
                                promoCodes[index]
                                    .title
                                    .toString()
                                    .toUpperCase(),
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    secondChild: Container(
                      width: double.maxFinite,
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Align(
                            alignment: Alignment.topRight,
                            child: TextButton(
                                onPressed: () {
                                  if (widget.price >= promoCodes[index].price) {
                                    if (promoCodes[index].isApplied) {
                                      toast('Coupon already applied.');
                                      return;
                                    }
                                    // Apply the coupon
                                    double discountAmount =
                                        (promoCodes[index].discount / 100) *
                                            widget.price;
                                    double newPrice =
                                        widget.price - discountAmount;
                                    setState(() {
                                      widget.price = newPrice;
                                      promoCodes[index].isApplied = true;
                                    });
                                    toast('Coupon applied!');
                                    // Show a success message (you can use a toast or a dialog)
                                  } else {
                                    // Show an error message
                                    toast('Not eligible for this coupon.');
                                  }
                                },
                                child: Text(
                                  'Apply'.toUpperCase(),
                                  style: myFont28_600.copyWith(
                                      color: Utils().lightBlue, fontSize: 15),
                                )),
                          ),
                          // const SizedBox(height: 4),
                          Text(
                            promoCodes[index].name.toUpperCase(),
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 20,
                              color: Utils().lightBlue,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(promoCodes[index].description.toString()),
                          const Spacer(),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            // Expanded(
            //   child: ListView.builder(
            //     shrinkWrap: true,
            //     itemCount: promoCodes.length,
            //     itemBuilder: (context, index) {
            //       return Card(
            //         child: Padding(
            //           padding: const EdgeInsets.all(12.0),
            //           child: Row(
            //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //             children: [
            //               Column(
            //                 crossAxisAlignment: CrossAxisAlignment.start,
            //                 children: [
            //                   Text(
            //                     "cupon code : ${promoCodes[index].name}"
            //                         .toUpperCase(),
            //                     style: myFont28_600,
            //                   ),
            //                   Text(
            //                       "${promoCodes[index].discount.toString()} % off"
            //                           .toUpperCase(),
            //                       style: myFont500)
            //                 ],
            //               ),
            //             ],
            //           ),
            //         ),
            //       );
            //     },
            //   ),
            // ),
            const Spacer(),
            PrimaryButton(
              text: "pay ${widget.price.toDouble()} QAR",
              onTap: () {
                BookingSummaryScreen(
                  subCost: widget.subCost ?? '',
                  subscriptionName: widget.subscriptionName ?? '',
                  coordinates: widget.coordinates,
                  serviceCost: widget.serviceCost,
                  serviceName: widget.serviceName,
                  carName: widget.carName,
                  carModel: widget.carModel,
                  slotDate: widget.slotDate,
                  packageName: widget.packageName,
                  // selectedSlotIndex: selectedSlotIndex,
                  selectedDate: widget.selectedDate,
                  address: widget.address,
                  price: widget.price,
                  selectedPackageIndex: widget.selectedPackageIndex,
                  selectedVehicleIndex: widget.selectedVehicleIndex,
                  noOfWash: widget.noOfWash,
                ).launch(context, pageRouteAnimation: PageRouteAnimation.Fade);
                log(" =>> packagex name ${widget.packageName}");
              },
            )
          ],
        ),
      ),
    ));
  }
}
