// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:animate_do/animate_do.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:nb_utils/nb_utils.dart';

import 'package:wype_user/booking/booking_summary_screen.dart';
import 'package:wype_user/common/appbar.dart';
import 'package:wype_user/common/login_filed.dart';
import 'package:wype_user/common/primary_button.dart';
import 'package:wype_user/constants.dart';
import 'package:wype_user/model/promo_code_model.dart';
import 'package:wype_user/profile/promo_codes.dart';

class AddCardScreen extends StatefulWidget {
  LatLng coordinates;
  var serviceName;
  var serviceCost;
  var selectedDate;
  String? carName;
  String? carModel;
  String address;
  int selectedVehicleIndex;
  int selectedPackageIndex;
  var slotDate;
  // int selectedSlotIndex;
  var price;
  String? washCount;
  String? packageName;
  Services? promoCode;
  AddCardScreen({
    Key? key,
    required this.coordinates,
    required this.serviceName,
    required this.serviceCost,
    this.selectedDate,
    this.carName,
    this.carModel,
    required this.address,
    required this.selectedVehicleIndex,
    required this.selectedPackageIndex,
    required this.slotDate,
    required this.price,
    this.washCount,
    this.packageName,
    this.promoCode,
  }) : super(key: key);

  @override
  State<AddCardScreen> createState() => _AddCardScreenState();
}

class _AddCardScreenState extends State<AddCardScreen> {
  TextEditingController cardNumberController = TextEditingController();
  TextEditingController expiryDateController = TextEditingController();
  TextEditingController cardHolderNameController = TextEditingController();
  TextEditingController cvvCodeController = TextEditingController();
  TextEditingController nickNameController = TextEditingController();
  String cardNumber = '';
  String expiryDate = '';
  String cardHolderName = '';
  String cvvCode = '';
  bool isCvvFocused = false;
  final _formKey = GlobalKey<FormState>();
  @override
  @override
  Widget build(BuildContext context) {
    log(" := selected carName ${widget.carName}");
    log("card lat long${widget.coordinates}");
    return Scaffold(
      appBar: commonAppbar('Add Card'),
      body: FadeIn(
          child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                20.height,
                Text(
                  'We accept Credit and Debit Cards from Visa, Mastercard | Sodexo, American Express, Maestro, Diners & Discover',
                  style: myFont500.copyWith(fontSize: 14),
                ),
                30.height,
                LoginFiled(
                  keyBord: TextInputType.number,
                  validator: (value) {
                    // Add your validation logic here
                    if (value == null || value.isEmpty || value.length != 16) {
                      return 'Please enter a valid card number';
                    }
                    return null;
                  },
                  controller: cardNumberController,
                  hintText: 'Card Number',
                  isObsecure: false,
                ),
                30.height,
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width: width(context) * 0.6,
                      child: LoginFiled(
                        keyBord: TextInputType.datetime,
                        validator: (value) {
                          // Add your validation logic here
                          if (value == null ||
                              value.isEmpty ||
                              value.length != 5) {
                            return 'Please enter a valid expiry date';
                          }
                          return null;
                        },
                        controller: expiryDateController,
                        hintText: 'Valid Through (MM/YY)',
                        isObsecure: false,
                      ),
                    ),
                    SizedBox(
                      width: width(context) * 0.25,
                      child: LoginFiled(
                        keyBord: TextInputType.number,
                        validator: (value) {
                          // Add your validation logic here
                          if (value == null ||
                              value.isEmpty ||
                              value.length != 3) {
                            return 'valid CVV';
                          }
                          return null;
                        },
                        controller: cvvCodeController,
                        hintText: 'CVV',
                        isObsecure: false,
                      ),
                    ),
                  ],
                ),
                30.height,
                LoginFiled(
                  validator: (value) {
                    // Add your validation logic here
                    if (value == null || value.isEmpty) {
                      return 'Please enter the cardholder name';
                    }
                    return null;
                  },
                  controller: cardHolderNameController,
                  hintText: 'Name on Card',
                  isObsecure: false,
                ),
                30.height,
                LoginFiled(
                  validator: (value) {
                    // Add your validation logic here
                    if (value == null || value.isEmpty) {
                      return 'Please enter the cardholder name';
                    }
                    return null;
                  },
                  controller: nickNameController,
                  hintText: 'Card Nickname (for easy identification)',
                  isObsecure: false,
                ),
                60.height,
                PrimaryButton(
                  text: 'add card',
                  onTap: () {
                    if (_formKey.currentState!.validate()) {
                      // If the form is valid, display a snackbar. In the real world,
                      // you'd often call a server or save the information in a database.
                      ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Processing Data')));
                    }
                    BookingSummaryScreen(
                      coordinates: widget.coordinates,
                      serviceCost: widget.serviceCost,
                      serviceName: widget.serviceName,
                      carModel: widget.carModel,
                      carName: widget.carName,
                      packageName: widget.packageName,
                      // selectedSlotIndex: widget.selectedSlotIndex,
                      address: widget.address,
                      price: widget.price,
                      selectedPackageIndex: widget.selectedPackageIndex,
                      selectedVehicleIndex: widget.selectedVehicleIndex,
                      washCount: widget.washCount,
                      selectedDate: widget.selectedDate,
                      slotDate: widget.slotDate,
                    ).launch(context,
                        pageRouteAnimation: PageRouteAnimation.Fade);
                  },
                ),
                30.height
              ],
            ),
          ),
        ),
      )),
    );
  }
}
