// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:nb_utils/nb_utils.dart';

import 'package:wype_user/booking/add_card.dart';
import 'package:wype_user/common/appbar.dart';
import 'package:wype_user/constants.dart';
import 'package:wype_user/model/promo_code_model.dart';

class PaymentOptions extends StatefulWidget {
  String? carName;
  String? carModel;
  DateTime? selectedDate;
  String address;
  int selectedVehicleIndex;
  int selectedPackageIndex;
  var packageName;
  var slotDate;
  var selectedSlotIndex;
  var price;
  String? washCount;
  Services? promoCode;
  PaymentOptions({
    Key? key,
    this.carName,
    this.carModel,
    this.selectedDate,
    required this.address,
    required this.selectedVehicleIndex,
    required this.selectedPackageIndex,
    this.packageName,
    required this.slotDate,
    required this.selectedSlotIndex,
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
    log(" =>>x selected List Dates ${widget.slotDate}");
    log(" =>>x package name ${widget.packageName}");
    log(" =>>x selected date ${widget.selectedDate}");
    log(" =>>x selected washtime ${widget.selectedSlotIndex}");
    log(" =>>x selected carName ${widget.carName}");
    log(" =>>x selected carModel ${widget.carModel}");
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
              selectedSlotIndex: widget.selectedSlotIndex,
              address: widget.address,
              price: widget.price,
              selectedPackageIndex: widget.selectedPackageIndex,
              selectedVehicleIndex: widget.selectedVehicleIndex,
              washCount: widget.washCount,
              selectedDate: widget.selectedDate,
              slotDate: widget.slotDate,
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

class PaymentContainer extends StatefulWidget {
  String? carName;
  String? carModel;
  var selectedDate;
  String address;
  int selectedVehicleIndex;
  var packageName;
  int selectedPackageIndex;
  var slotDate;
  int selectedSlotIndex;
  var price;
  String? washCount;
  Services? promoCode;
  PaymentContainer({
    Key? key,
    this.carName,
    this.carModel,
    this.selectedDate,
    required this.address,
    required this.selectedVehicleIndex,
    this.packageName,
    required this.selectedPackageIndex,
    required this.slotDate,
    required this.selectedSlotIndex,
    required this.price,
    this.washCount,
    this.promoCode,
  }) : super(key: key);

  @override
  State<PaymentContainer> createState() => _PaymentContainerState();
}

class _PaymentContainerState extends State<PaymentContainer> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          border: Border.all(color: lightGray),
          borderRadius: const BorderRadius.all(Radius.circular(10))),
      child: Column(
        children: [
          ListTile(
            leading: Icon(
              FontAwesomeIcons.ccVisa,
              color: Utils().lightBlue,
              size: 40,
            ),
            title: Text(
              'Personal',
              // ignore: deprecated_member_use
              style: myFont28_600,
            ),
            subtitle: const Text(
              'show saved card',
            ),
            trailing: const Icon(
              Icons.arrow_forward_ios,
              color: gray,
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: Divider(),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: ListTile(
                leading: Icon(
                  FontAwesomeIcons.bank,
                  color: Utils().lightBlue,
                  size: 40,
                ),
                title: Text(
                  'Add Credit or Debit Cards', style: myFont28_600,
                  // ignore: deprecated_member_use
                ),
                trailing: TextButton(
                    onPressed: () {
                      AddCardScreen(
                        packageName: widget.packageName,
                        selectedSlotIndex: widget.selectedSlotIndex,
                        address: widget.address,
                        price: widget.price,
                        selectedPackageIndex: widget.selectedPackageIndex,
                        selectedVehicleIndex: widget.selectedVehicleIndex,
                        washCount: widget.washCount,
                        selectedDate: widget.selectedDate,
                        slotDate: widget.slotDate,
                      ).launch(context,
                          pageRouteAnimation: PageRouteAnimation.Fade);
                      log(" =>> package send card screen name ${widget.packageName}");
                    },
                    child: Text(
                      'add'.toUpperCase(),
                      style: myFont28_600.copyWith(color: Utils().lightBlue),
                    ))),
          ),
        ],
      ),
    );
  }
}
