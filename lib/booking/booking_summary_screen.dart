// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:animate_do/animate_do.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:nb_utils/nb_utils.dart';

import 'package:wype_user/booking/payment_response.dart';
import 'package:wype_user/booking/payment_success_screen.dart';
import 'package:wype_user/common/appbar.dart';
import 'package:wype_user/common/primary_button.dart';
import 'package:wype_user/constants.dart';
import 'package:wype_user/model/add_package_model.dart';
import 'package:wype_user/model/booking.dart';
import 'package:wype_user/model/promo_code_model.dart';
import 'package:wype_user/services/firebase_services.dart';

class BookingSummaryScreen extends StatefulWidget {
  String? carName;
  String? carModel;
  var selectedDate;
  String address;
  int selectedVehicleIndex;
  int selectedPackageIndex;
  var slotDate;
  int selectedSlotIndex;
  var price;
  String? washCount;
  Services? promoCode;
  String? packageName;
  BookingSummaryScreen({
    Key? key,
    this.selectedDate,
    required this.address,
    required this.selectedVehicleIndex,
    required this.selectedPackageIndex,
    required this.slotDate,
    required this.selectedSlotIndex,
    required this.price,
    this.packageName,
    this.washCount,
    this.promoCode,
  }) : super(key: key);
  FirebaseService firebaseService = FirebaseService();
  @override
  State<BookingSummaryScreen> createState() => _BookingSummaryScreenState();
}

class _BookingSummaryScreenState extends State<BookingSummaryScreen> {
  FirebaseService firebaseService = FirebaseService();
  @override
  Widget build(BuildContext context) {
    log(" =>> package index ${widget.selectedPackageIndex}");
    return Scaffold(
      backgroundColor: white,
      appBar: commonAppbar('Booking Summary'),
      body: FadeIn(
          child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FutureBuilder<List<PackageNameModel>>(
              future: fetchPackages(),
              builder: (context, snapshot) {
                if (snapshot.hasData && snapshot.data != null) {
                  List<PackageNameModel> packages = snapshot.data!;
                  int selectedPackageIndex = widget.selectedPackageIndex;

                  // Always add a container for 1 wash
                  packages.add(PackageNameModel(packageName: '1 Wash'));

                  return SizedBox(
                    height: 80,
                    child: ListView.separated(
                      physics: const AlwaysScrollableScrollPhysics(),
                      separatorBuilder: (context, index) =>
                          const SizedBox(width: 12),
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      itemCount: packages.length,
                      itemBuilder: (context, index) {
                        PackageNameModel package = packages[index];
                        bool isSelected = false;
                        if (selectedPackageIndex == -1 &&
                            index == packages.length - 1) {
                          isSelected = true;
                        } else if (index == selectedPackageIndex) {
                          isSelected = true;
                        }

                        return Container(
                          height: 70,
                          decoration: BoxDecoration(
                            color: isSelected ? Utils().softBlue : white,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                                color: isSelected ? Utils().lightBlue : gray),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 18),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  package.packageName!.split(' ')[0],
                                  style: const TextStyle(
                                    fontSize: 25,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const Text(
                                  'Washes',
                                  style: TextStyle(fontWeight: FontWeight.w500),
                                )
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  );
                } else if (snapshot.hasError) {
                  return Text("Error: ${snapshot.error}");
                }

                // By default, show a loading spinner.
                return const Center(child: CircularProgressIndicator());
              },
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
                  // firebaseService.createBookings(BookingModel(bookingStatus: '', serviceType: widget.packageName.toString(), userId:userData!.id.toString(), address: widget.address, latlong: LatLngModel(lat: 100, long: 00), vehicle: widget., washCount: widget.washCount, washTimings: widget.selectedDate, addService: [], removeService: []), true);
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
