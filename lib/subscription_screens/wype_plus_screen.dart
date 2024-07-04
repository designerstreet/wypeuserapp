// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:nb_utils/nb_utils.dart';

import 'package:wype_user/add_remove_service/new_add_remove_servise.dart';
import 'package:wype_user/common/wype_plus_container.dart';
import 'package:wype_user/common/wype_plus_row.dart';
import 'package:wype_user/constants.dart';
import 'package:wype_user/model/add_package_model.dart';
import 'package:wype_user/services/firebase_services.dart';

class WypePlusPlans extends StatefulWidget {
  LatLng coordinates;
  String? dueration;
  var noOfWash;
  String subscriptionName;
  var cost;
  String address;
  int selectedVehicleIndex;
  String? carName;
  String? carModel;
  int? selectedSubscriptionPackageIndex;
  // String totalCost;
  WypePlusPlans({
    Key? key,
    required this.coordinates,
    this.dueration,
    required this.noOfWash,
    required this.subscriptionName,
    required this.cost,
    required this.address,
    required this.selectedVehicleIndex,
    this.carName,
    this.carModel,
    this.selectedSubscriptionPackageIndex,
  }) : super(key: key);

  @override
  State<WypePlusPlans> createState() => _WypePlusPlansState();
}

class _WypePlusPlansState extends State<WypePlusPlans> {
  FirebaseService firebaseService = FirebaseService();
  int selectedPackageIndex = 0;
  bool isSelected = true;

  @override
  void initState() {
    // TODO: implement initState
    // fetchPackages();
    packagesFuture = firebaseService.fetchPackages();
    super.initState();
  }

  Future<List<PackageNameModel>>? packagesFuture;
  var package;
  double? calculatedCost;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.subscriptionName,
          style: myFont28_600,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
        child: Column(
          children: [
            20.height,
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'monthly subscriptions'.toUpperCase(),
                  style: const TextStyle(color: gray),
                ),
              ],
            ),
            20.height,
            ListView.separated(
                physics: const ScrollPhysics(),
                separatorBuilder: (context, index) => const SizedBox(
                      height: 15,
                    ),
                itemCount: widget.cost.length,
                shrinkWrap: true,
                itemBuilder: (context, index) => InkWell(
                      onTap: () {
                        selectedPackageIndex = index ?? 0;
                        setState(() {});
                      },
                      splashColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      child: PlusContainer(
                          img: widget.noOfWash[index] == '1'
                              ? 'assets/images/1.png'
                              : widget.noOfWash[index] == '4'
                                  ? 'assets/images/4.png'
                                  : widget.noOfWash[index] == '8'
                                      ? 'assets/images/8.png'
                                      : 'assets/images/12.png',
                          washTitle: "${widget.noOfWash[index]} Wype Wash",
                          priceTitle: "${widget.cost[index]} QAR",
                          isSelected: selectedPackageIndex == index),
                    )),

            const Spacer(),

            wypePlusRow(
                'Cart Total',
                selectedPackageIndex >= 0
                    ? widget.cost[selectedPackageIndex]
                    : [], () {
              // SelectSlot(
              //         noOfWash: widget.noOfWash,
              //         carName: widget.carName,
              //         carModel: widget.carModel,
              //         packageName: widget.subscriptionName,
              //         address: widget.address,
              //         price: widget.cost,
              //         selectedPackageIndex: selectedPackageIndex ?? -1,
              //         selectedVehicleIndex: widget.selectedVehicleIndex,
              //         saveLocation: true)
              //     .launch(context, pageRouteAnimation: PageRouteAnimation.Fade);

              CustomService(
                      subCost: widget.cost[0],
                      // subCost: selectedPackageIndex >= 0
                      //     ? widget.cost[selectedPackageIndex]
                      //     : [],
                      subscriptionName: widget.subscriptionName,
                      coordinates: widget.coordinates,
                      duration: widget.dueration,
                      noOfWash: widget.noOfWash,
                      carName: widget.carName,
                      carModel: widget.carModel,
                      packageName: selectedPackageIndex >= 0
                          ? widget.subscriptionName[selectedPackageIndex]
                          : [],
                      address: widget.address,
                      price: selectedPackageIndex >= 0
                          ? widget.cost[selectedPackageIndex]
                          : [],
                      selectedPackageIndex: selectedPackageIndex,
                      selectedVehicleIndex: widget.selectedVehicleIndex,
                      saveLocation: true)
                  .launch(context, pageRouteAnimation: PageRouteAnimation.Fade);
              log(selectedPackageIndex);

              log(" =>> package name:: ${selectedPackageIndex ?? -1}");
            }, 'select services'),

            30.height
            // const Text('220 QAR')
          ],
        ),
      ),
    );
  }
}
