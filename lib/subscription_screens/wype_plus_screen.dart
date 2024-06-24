// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:animate_do/animate_do.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';

import 'package:wype_user/add_remove_service/new_add_remove_servise.dart';
import 'package:wype_user/add_remove_service/old_add_remove_service.dart';
import 'package:wype_user/common/extra_service.dart';
import 'package:wype_user/common/primary_button.dart';
import 'package:wype_user/common/wype_plus_container.dart';
import 'package:wype_user/common/wype_plus_row.dart';
import 'package:wype_user/constants.dart';
import 'package:wype_user/model/add_package_model.dart';
import 'package:wype_user/model/add_service_model.dart';
import 'package:wype_user/model/promo_code_model.dart';
import 'package:wype_user/provider/language.dart';
import 'package:wype_user/select_slot/select_slot.dart';
import 'package:wype_user/services/firebase_services.dart';

class WypePlusPlans extends StatefulWidget {
  LatLng coordinates;
  String? dueration;
  String noOfWash;
  String subscriptionName;
  String cost;
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
  int? selectedPackageIndex;
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
    log(widget.address);
    log(widget.subscriptionName);
    log(widget.noOfWash);
    log(widget.dueration);
    log("lat Long ${widget.coordinates}");
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.subscriptionName,
          style: myFont28_600,
        ),
      ),
      body: FadeIn(
          child: Padding(
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
            Expanded(
              child: FutureBuilder<List<PackageNameModel>>(
                future: packagesFuture,
                builder: (context, snapshot) {
                  if (snapshot.hasData && snapshot.data != null) {
                    List<PackageNameModel> packages = snapshot.data!;
                    return ListView.separated(
                      physics: const ScrollPhysics(),
                      separatorBuilder: (context, index) =>
                          const SizedBox(height: 15),
                      shrinkWrap: true,
                      itemCount: packages.length, // use the length of packages
                      itemBuilder: (context, index) {
                        package = packages[index];

                        double costForCurrentIndex =
                            package.packageName == '1 Wype wash'
                                ? double.parse(widget.cost)
                                : double.parse(widget.cost) * (index) * 4;
                        return InkWell(
                          splashColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                          onTap: () {
                            // Logic to handle onTap here

                            log('Package Selected: ${package.packageName}');
                            selectedPackageIndex = index;
                            calculatedCost = costForCurrentIndex;

                            setState(() {});
                          },
                          child: Column(
                            children: [
                              PlusContainer(
                                isSelected: selectedPackageIndex == index,
                                img: package.packageName == '4 Wype wash'
                                    ? 'assets/images/4.png'
                                    : package.packageName == '8 Wype wash'
                                        ? 'assets/images/8.png'
                                        : package.packageName == '12 Wype wash'
                                            ? 'assets/images/12.png'
                                            : 'assets/images/1.png', // You might change this according to package specifics if needed
                                washTitle:
                                    '${package.packageName}', // Display package name
                                priceTitle: selectedPackageIndex == index
                                    ? calculatedCost!.toStringAsFixed(
                                        2) // Display price for selected package
                                    : costForCurrentIndex.toStringAsFixed(
                                        2), // Use relevant data
                                disPrice: '276', // Use relevant data
                                per: '20%', // Use relevant data
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  } else if (snapshot.hasError) {
                    return Text("Error: ${snapshot.error}");
                  }
                  // By default, show a loading spinner.
                  return const Center(child: CircularProgressIndicator());
                },
              ),
            ),

            wypePlusRow(
                'Cart Total', calculatedCost?.toStringAsFixed(2) ?? widget.cost,
                () {
              log(widget.cost);
              // SelectSlot(
              //         noOfWash: widget.noOfWash,
              //         carName: widget.carName,
              //         carModel: widget.carModel,
              //         packageName: package.packageName,
              //         address: widget.address,
              //         price: calculatedCost?.toStringAsFixed(2) ?? widget.cost,
              //         selectedPackageIndex: selectedPackageIndex ?? -1,
              //         selectedVehicleIndex: widget.selectedVehicleIndex,
              //         saveLocation: true)
              //     .launch(context, pageRouteAnimation: PageRouteAnimation.Fade);

              CustomService(
                      subCost: widget.cost,
                      subscriptionName: widget.subscriptionName,
                      coordinates: widget.coordinates,
                      duration: widget.dueration,
                      noOfWash: widget.noOfWash,
                      carName: widget.carName,
                      carModel: widget.carModel,
                      packageName: package.packageName,
                      address: widget.address,
                      price: calculatedCost?.toStringAsFixed(2) ?? widget.cost,
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
      )),
    );
  }
}
