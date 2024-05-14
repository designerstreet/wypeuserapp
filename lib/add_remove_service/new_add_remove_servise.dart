// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:nb_utils/nb_utils.dart';

import 'package:wype_user/booking/select_slot.dart';
import 'package:wype_user/common/add_remove_widget.dart';
import 'package:wype_user/common/wype_plus_container.dart';
import 'package:wype_user/common/wype_plus_row.dart';
import 'package:wype_user/constants.dart';
import 'package:wype_user/model/add_service_model.dart';
import 'package:wype_user/model/promo_code_model.dart';
import 'package:wype_user/services/firebase_services.dart';

class CustomService extends StatefulWidget {
  String washType;
  String? carName;
  String? carModel;
  String address;
  int selectedVehicleIndex;
  int? selectedPackageIndex;
  var packageName;
  var price;
  // String? washCount;

  Services? promoCode;
  bool saveLocation;
  Function()? onTap;
  CustomService({
    Key? key,
    required this.washType,
    this.carName,
    this.carModel,
    required this.address,
    required this.selectedVehicleIndex,
    this.selectedPackageIndex,
    required this.packageName,
    required this.price,
    // required this.washCount,

    this.promoCode,
    required this.saveLocation,
    this.onTap,
  }) : super(key: key);

  @override
  State<CustomService> createState() => _CustomServiceState();
}

class _CustomServiceState extends State<CustomService> {
  bool isLoading = true;
  double? calculatedCost;
  Map<int, int> itemCounts = {}; // Initialize with index as key, count as value

  void add(int index) {
    setState(() {
      itemCounts[index] = (itemCounts[index] ?? 0) + 1;

      // Increment or initialize
    });
  }

  void dec(int index) {
    setState(() {
      if (itemCounts[index] != null && itemCounts[index]! > 0) {
        itemCounts[index] = itemCounts[index]! - 1; // Decrement
      }
    });
  }

  Future<List<OfferServiceModel>>? offerData;
  var offer;

  List offerList = [
    "Full Exterior Wash",
    "Tire & Dashboard Polish",
    "Rim Cleaning",
    "Interior Vacuuming",
    "Interior Glass Deep Clean",
    "Sanitization & Air Freshener"
  ];
  @override
  void initState() {
    super.initState();
    // fetchOfferData();
    offerData = getServiceOffer();
    getServiceOffer();
    calculatedCost = 0.0;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        title: Text(
          'Custom Service',
          style: myFont28_600,
        ),
      ),
      body: FadeIn(
          child: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FutureBuilder<List<OfferServiceModel>>(
                future: offerData,
                builder: (context, snapshot) {
                  if (snapshot.hasData && snapshot.data != null) {
                    List<OfferServiceModel> serviceOffers = snapshot.data!;

                    return SizedBox(
                      height: height(context) * 0.80,
                      child: ListView.separated(
                        physics: const ScrollPhysics(),
                        shrinkWrap: true,
                        separatorBuilder: (context, index) => const SizedBox(
                          height: 20,
                        ),
                        itemCount: serviceOffers.length,
                        itemBuilder: (context, index) {
                          var service = serviceOffers[index];
                         
                          return Column(
                            children: [
                              PlusContainer(
                                  innerWidget: Container(
                                    decoration: BoxDecoration(
                                        color: Utils().softBlue,
                                        borderRadius: BorderRadius.circular(30),
                                        border: Border.all(
                                            color: Utils().lightBlue)),
                                    child: Row(
                                      children: [
                                        IconButton(
                                            onPressed: () {
                                              dec(index);
                                            },
                                            icon: FaIcon(
                                              FontAwesomeIcons.minus,
                                              size: 15,
                                              color: Utils().blueDark,
                                            )),
                                        Text(
                                          itemCounts[index]?.toString() ?? '0',
                                          textAlign: TextAlign.center,
                                          style: myFont28_600.copyWith(
                                            color: Utils().lightBlue,
                                          ),
                                        ),
                                        IconButton(
                                            onPressed: () {
                                              add(index);
                                              calculatedCost = 0.0;
                                              for (var i = 0;
                                                  i < itemCounts.length;
                                                  i++) {
                                                if (itemCounts.containsKey(i)) {
                                                  var currentServicePrice =
                                                      double.tryParse(
                                                              serviceOffers[i]
                                                                  .serviceCost) ??
                                                          0.0;
                                                  calculatedCost +=
                                                      (currentServicePrice +
                                                              double.tryParse(
                                                                  widget
                                                                      .price)!) *
                                                          itemCounts[
                                                              i]!; // Sum up costs from all items
                                                }
                                              }
                                              setState(
                                                  () {}); // Update the UI with new total cost
                                            },
                                            icon: FaIcon(
                                              FontAwesomeIcons.plus,
                                              color: Utils().blueDark,
                                              size: 15,
                                            )),
                                      ],
                                    ),
                                  ),
                                  img: 'assets/images/deepclean.png',
                                  washTitle: service.serviceName,
                                  priceTitle: service.serviceCost,
                                  isSelected: false),
                              10.height,
                            ],
                          );
                        },
                      ),
                    );
                  } else if (snapshot.hasError) {
                    return Center(child: Text(snapshot.error.toString()));
                  }
                  return const Center(child: CircularProgressIndicator());
                }),
            const Spacer(),
            wypePlusRow('Cart Total', widget.price, () {
              // SelectSlot(
              //         packageName: '',
              //         address: widget.address,
              //         price: widget.priceTotal,
              //         selectedPackageIndex: widget.selectedPackageIndex!,
              //         selectedVehicleIndex: widget.selectedVehicleIndex,
              //         saveLocation: false)
              //     .launch(context, pageRouteAnimation: PageRouteAnimation.Fade);
            }, 'select slot')
          ],
        ),
      )),
    ));
  }
}
