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
  DateTime? selectedDate;
  String address;
  int selectedVehicleIndex;
  int selectedPackageIndex;
  var slotDate;
  int selectedSlotIndex;
  var price;
  String? washCount;
  Services? promoCode;
  PaymentOptions({
    Key? key,
    required this.address,
    required this.selectedVehicleIndex,
    required this.selectedPackageIndex,
    required this.selectedSlotIndex,
    required this.price,
    this.selectedDate,
    this.washCount,
    this.promoCode,
  }) : super(key: key);

  @override
  State<PaymentOptions> createState() => _PaymentOptionsState();
}

class _PaymentOptionsState extends State<PaymentOptions> {
  @override
  Widget build(BuildContext context) {
    log(widget.selectedSlotIndex);
    log(widget.slotDate);
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
            const PaymentContainer(),
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

class PaymentContainer extends StatelessWidget {
  const PaymentContainer({
    super.key,
  });

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
                      const AddCardScreen().launch(context,
                          pageRouteAnimation: PageRouteAnimation.Fade);
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
