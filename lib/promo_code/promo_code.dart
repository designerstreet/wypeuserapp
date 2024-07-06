// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:nb_utils/nb_utils.dart';

import 'package:wype_user/common/appbar.dart';
import 'package:wype_user/constants.dart';
import 'package:wype_user/model/promo_code_old.dart';
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
      body: Column(
        children: [
          ListView.builder(
            shrinkWrap: true,
            itemCount: promoCodes.length,
            itemBuilder: (context, index) {
              return Card(
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "cupon code : ${promoCodes[index].name}"
                                .toUpperCase(),
                            style: myFont28_600,
                          ),
                          Text(
                              "${promoCodes[index].discount.toString()} % off"
                                  .toUpperCase(),
                              style: myFont500)
                        ],
                      ),
                      TextButton(
                          onPressed: () {
                            if (widget.price >= promoCodes[index].price) {
                              // Apply the coupon
                              double discountAmount =
                                  (promoCodes[index].discount / 100) *
                                      widget.price;
                              double newPrice = widget.price - discountAmount;
                              setState(() {
                                widget.price = newPrice;
                              });

                              // Show a success message (you can use a toast or a dialog)
                              toast('Coupon applied!');
                            } else {
                              // Show an error message
                              toast('Not eligible for this coupon.');
                            }
                          },
                          child: Text(
                            'Apply code'.toUpperCase(),
                            style:
                                myFont28_600.copyWith(color: Utils().lightBlue),
                          ))
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    ));
  }
}
