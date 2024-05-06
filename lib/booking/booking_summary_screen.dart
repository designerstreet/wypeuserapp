// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:nb_utils/nb_utils.dart';

import 'package:wype_user/booking/payment_response.dart';
import 'package:wype_user/booking/payment_success_screen.dart';
import 'package:wype_user/common/appbar.dart';
import 'package:wype_user/common/primary_button.dart';
import 'package:wype_user/constants.dart';
import 'package:wype_user/model/promo_code_model.dart';

class BookingSummaryScreen extends StatefulWidget {
  DateTime? selectedDate;
  String address;
  int selectedVehicleIndex;
  int selectedPackageIndex;
  var slotDate;
  int selectedSlotIndex;
  var price;
  String? washCount;
  Services? promoCode;
  BookingSummaryScreen({
    Key? key,
    this.selectedDate,
    required this.address,
    required this.selectedVehicleIndex,
    required this.selectedPackageIndex,
    required this.slotDate,
    required this.selectedSlotIndex,
    required this.price,
    this.washCount,
    this.promoCode,
  }) : super(key: key);

  @override
  State<BookingSummaryScreen> createState() => _BookingSummaryScreenState();
}

class _BookingSummaryScreenState extends State<BookingSummaryScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: white,
      appBar: commonAppbar('Booking Summary'),
      body: FadeIn(
          child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 80,
              child: ListView.separated(
                physics: const AlwaysScrollableScrollPhysics(),
                separatorBuilder: (context, index) => const SizedBox(
                  width: 12,
                ),
                shrinkWrap: true,
                itemCount: 4,
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  return Container(
                    height: 70,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: gray)),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 18),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            '1',
                            style: myFont28_600.copyWith(fontSize: 25),
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            'Washes',
                            style: myFont500,
                          )
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            10.height,
            const Divider(),
            Text(
              'Bill Details',
              style: myFont28_600.copyWith(fontSize: 18),
            ),
            15.height,
            Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: gray)),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Service Total',
                          style: myFont500.copyWith(color: gray),
                        ),
                        Text(widget.price,
                            style: myFont500.copyWith(color: gray))
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Service Total',
                          style: myFont500.copyWith(color: gray),
                        ),
                        Text(widget.price,
                            style: myFont500.copyWith(color: gray))
                      ],
                    ),
                    const Divider(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'To Pay',
                          style: myFont28_600,
                        ),
                        Text(widget.price, style: myFont28_600)
                      ],
                    )
                  ],
                ),
              ),
            ),
            const Spacer(),
            Column(
              children: [
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                  child: Row(
                    children: [
                      const FaIcon(
                        FontAwesomeIcons.ccVisa,
                        size: 30,
                        color: skyBlue,
                      ),
                      Text('    pay ${widget.price} QAR'.toUpperCase(),
                          textAlign: TextAlign.left,
                          style:
                              myFont500.copyWith(fontWeight: FontWeight.w600)),
                      const Spacer(),
                      Text(
                        'change'.toUpperCase(),
                        style: myFont28_600.copyWith(color: Utils().skyBlue),
                      ),
                      Icon(
                        Icons.arrow_forward_ios,
                        color: Utils().skyBlue,
                        size: 18,
                      )
                    ],
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: PrimaryButton(
                text: 'Proceed to checkout',
                onTap: () {
                  const PaymentSuccessScreen().launch(context,
                      pageRouteAnimation: PageRouteAnimation.Fade);
                },
              ),
            ),
            const SizedBox(
              height: 30,
            )
          ],
        ),
      )),
    );
  }
}
