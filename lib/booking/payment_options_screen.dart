// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:nb_utils/nb_utils.dart';

import 'package:wype_user/booking/add_card.dart';
import 'package:wype_user/common/appbar.dart';
import 'package:wype_user/common/payment_container.dart';
import 'package:wype_user/constants.dart';
import 'package:wype_user/model/promo_code_model.dart';

class PaymentOptions extends StatefulWidget {
  String subCost;
  String subscriptionName;
  LatLng coordinates;
  var serviceName;
  var serviceCost;
  String? carName;
  String? carModel;
  DateTime? selectedDate;
  String address;
  int selectedVehicleIndex;
  int selectedPackageIndex;
  var packageName;
  var slotDate;
  // var selectedSlotIndex;
  var price;
  String? washCount;
  Services? promoCode;
  PaymentOptions({
    Key? key,
    required this.subCost,
    required this.subscriptionName,
    required this.coordinates,
    required this.serviceName,
    required this.serviceCost,
    this.carName,
    this.carModel,
    this.selectedDate,
    required this.address,
    required this.selectedVehicleIndex,
    required this.selectedPackageIndex,
    this.packageName,
    required this.slotDate,
    required this.price,
    this.washCount,
    this.promoCode,
  }) : super(key: key);

  @override
  State<PaymentOptions> createState() => _PaymentOptionsState();
}

class _PaymentOptionsState extends State<PaymentOptions> {
  @override
  Widget build(BuildContext context) {
    // log(" =>>x selected List Dates ${widget.slotDate}");
    // log(" =>>x package name ${widget.packageName}");
    // log(" =>>x selected date ${widget.selectedDate}");

    // log(" =>>x selected carName ${widget.carName}");
    // log(" =>>x selected carModel ${widget.carModel}");
    // log(" =>>x service name ${widget.serviceName}");
    log(" =>>x lat long payment op ${widget.coordinates}");
    log(" =>>x sub name ${widget.subscriptionName}");
    return Scaffold(
      appBar: commonAppbar('Payment Options'),
      body: FadeIn(
          child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
        child: Column(
          children: [
            const ListTile(
              contentPadding: EdgeInsets.all(8),
              shape: RoundedRectangleBorder(
                  side: BorderSide(color: lightGray),
                  borderRadius: BorderRadius.all(Radius.circular(10))),
              leading: Icon(
                Icons.apple,
                size: 40,
              ),
              title: Text(
                'Apple Pay',
                // ignore: deprecated_member_use
                textScaleFactor: 1.5,
              ),
              trailing: Icon(
                Icons.arrow_forward_ios,
                color: gray,
              ),
            ),
            20.height,
            Text(
              'cards'.toUpperCase(),
              style: myFont500.copyWith(color: gray, fontSize: 17),
            ),
            10.height,
            PaymentContainer(
              onTap: () {
                AddCardScreen(
                  subCost: widget.subCost,
                  subscriptionName: widget.subscriptionName,
                  coordinates: widget.coordinates,
                  carModel: widget.carModel,
                  carName: widget.carName,
                  serviceName: widget.serviceName,
                  serviceCost: widget.serviceCost,
                  packageName: widget.packageName,
                  address: widget.address,
                  price: widget.price,
                  selectedPackageIndex: widget.selectedPackageIndex,
                  selectedVehicleIndex: widget.selectedVehicleIndex,
                  washCount: widget.washCount,
                  selectedDate: widget.selectedDate,
                  slotDate: widget.slotDate,
                ).launch(context, pageRouteAnimation: PageRouteAnimation.Fade);
                log(" =>> package send card screen name ${widget.packageName}");
              },
            ),
            20.height,
            Text(
              'wallets'.toUpperCase(),
              style: myFont500.copyWith(color: gray, fontSize: 17),
            ),
            10.height,
          ],
        ),
      )),
    );
  }
}
