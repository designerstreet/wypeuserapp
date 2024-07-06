// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:animate_do/animate_do.dart';
import 'package:credit_card_form/credit_card_form.dart';
import 'package:credit_card_form/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:nb_utils/nb_utils.dart';

import 'package:wype_user/booking/booking_summary_screen.dart';
import 'package:wype_user/common/appbar.dart';
import 'package:wype_user/common/login_filed.dart';
import 'package:wype_user/common/primary_button.dart';
import 'package:wype_user/constants.dart';
import 'package:wype_user/model/promo_code_old.dart';
import 'package:wype_user/profile/promo_codes.dart';

class AddCardScreen extends StatefulWidget {
  String subCost;
  String subscriptionName;
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
    required this.subCost,
    required this.subscriptionName,
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
  CreditCardController controller = CreditCardController();

  final _formKey = GlobalKey<FormState>();

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
                Text(
                  'We accept Credit and Debit Cards from Visa, Mastercard | Sodexo, American Express, Maestro, Diners & Discover',
                  style: myFont500.copyWith(fontSize: 14),
                ),
                30.height,
                // CreditCardForm(
                //   controller: controller,
                //   theme: CreditCardLightTheme(),
                //   onChanged: (CreditCardResult isCreditCard) {
                //     log(isCreditCard.cardNumber);
                //     log(isCreditCard.cardHolderName);
                //     log(isCreditCard.expirationMonth);
                //     log(isCreditCard.expirationYear);
                //     log(isCreditCard.cardType);
                //     log(isCreditCard.cvc);
                //   },
                // ),

                20.height,
                LoginFiled(
                  prefixIcon: const Icon(Icons.credit_card),
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    CardNumberInputFormatter(),
                    LengthLimitingTextInputFormatter(16)
                  ],
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
                        inputFormatters: [
                          CardExpirationFormatter(),
                          LengthLimitingTextInputFormatter(5)
                        ],
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
                        inputFormatters: [
                          CardNumberInputFormatter(),
                          LengthLimitingTextInputFormatter(3)
                        ],
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
                      BookingSummaryScreen(
                        subCost: widget.subCost,
                        subscriptionName: widget.subscriptionName,
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

                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        duration: Duration(seconds: 1),
                        content: Text('Card added'),
                        backgroundColor: greenColor,
                      ));
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                          backgroundColor: redColor,
                          content: Text('Enter Full card Details')));
                    }
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

class CardExpiryInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    var text = newValue.text;

    if (newValue.selection.baseOffset == 0) {
      return newValue;
    }

    text = text.replaceAll('/', '');
    var newText = '';
    if (text.length >= 2) {
      newText = '${text.substring(0, 2)}/${text.substring(2)}';
    } else {
      newText = text;
    }

    return newValue.copyWith(
        text: newText,
        selection: TextSelection.collapsed(offset: newText.length));
  }
}
