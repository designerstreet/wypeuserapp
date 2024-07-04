import 'dart:async';

import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';
import 'package:wype_user/constants.dart';
import 'package:wype_user/home/home.dart';
import 'package:wype_user/home/root.dart';
import 'package:wype_user/model/booking.dart';
import 'package:wype_user/model/dibsy_res.dart';
import 'package:wype_user/my_booking/my_booking_new.dart';
import 'package:wype_user/provider/language.dart';
import 'package:wype_user/services/firebase_services.dart';
import 'package:wype_user/services/payment_services.dart';

import '../common/primary_button.dart';

class PaymentResponse extends StatefulWidget {
  String id;
  BookingModel? booking;
  bool saveLocation;
  double amount;
  PaymentResponse(
      {super.key,
      required this.id,
      required this.amount,
      required this.saveLocation,
      this.booking});

  @override
  State<PaymentResponse> createState() => _PaymentResponseState();
}

class _PaymentResponseState extends State<PaymentResponse> {
  bool isLoading = true;
  bool isFail = false;
  bool isSucess = false;
  PaymentModel? paymentStatus;
  Timer? cronTimer;
  FirebaseService firebaseService = FirebaseService();

  @override
  void initState() {
    super.initState();
    getPaymenStatuss();
  }

  @override
  void dispose() {
    super.dispose();
    cronTimer?.cancel();
  }

  setLoader(bool key, bool val) {
    setState(() {
      key = val;
    });
  }

  getPaymenStatuss() async {
    setLoader(isLoading, true);
    cronTimer = Timer.periodic(const Duration(seconds: 3), (Timer timer) async {
      paymentStatus = await checkStatus(widget.id);
      if (paymentStatus != null && paymentStatus?.status == "succeeded") {
        isLoading = false;
        isFail = false;
        isSucess = true;
        setState(() {});
        timer.cancel();
        cronTimer?.cancel();
        if (widget.booking == null) {
          firebaseService.updateWallet(widget.amount).then((success) {
            if (success) {
              userData?.wallet = (userData?.wallet ?? 0) + widget.amount;
              setState(() {});
              // Optionally show a toast or notification about the successful update
            } else {
              // Handle the error case, maybe show a notification to the user
              log("Failed to update the wallet on Firestore.");
            }
          });
        }

        // if (widget.booking == null) {
        //   userData?.wallet = (userData?.wallet ?? 0) + widget.amount;
        //   firebaseService.updateWallet(widget.amount);
        //   setState(() {});
        // }
        else {
          await firebaseService.createBookings(
              widget.booking!, widget.saveLocation ?? false);
          log(widget.booking);
        }
      } else if (paymentStatus != null && paymentStatus!.status == "failed") {
        isLoading = false;
        isFail = true;
        isSucess = false;
        setState(() {});
        timer.cancel();
        cronTimer?.cancel();
      } else {
        isLoading = true;
        setState(() {});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    var userLang = Provider.of<UserLang>(context, listen: true);

    return Scaffold(
        backgroundColor: white,
        body: isLoading
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CircularProgressIndicator(
                    color: darkGradient,
                  ),
                  30.height,
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Text(
                        userLang.isAr
                            ? "التحقق من حالة الدفع. من فضلك لا تضغط مرة أخرى"
                            : "Checking for Payment Status. Please dont press back",
                        textAlign: TextAlign.center,
                        style: myFont28_600),
                  ),
                ],
              )
            : Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/images/tick.png',
                      height: height(context) * 0.2,
                    ),
                    Text(
                      'Sit Back and Relax',
                      style: myFont28_600.copyWith(fontSize: 25),
                    ),
                    const Text('You payment was completed Successfully!'),
                    20.height,
                    PrimaryButton(
                      text: 'my booking',
                      onTap: () {
                        const RootPage().launch(context);
                        // MyBooking(
                        //   address: widget.booking?.address.toString(),
                        // ).launch(context,
                        //     pageRouteAnimation: PageRouteAnimation.Fade);
                      },
                    ),
                    // TextButton(
                    //     onPressed: () {},+0
                    //     child: Text(
                    //       'download receipt'.toUpperCase(),
                    //       style: myFont28_600.copyWith(color: Utils().lightBlue),
                    //     ))
                  ],
                ),
              )

        //  SizedBox(
        //     height: height(context),
        //     width: width(context),
        //     child: FadeIn(
        //         child: isSucess
        //             ? Column(
        //                 mainAxisAlignment: MainAxisAlignment.center,
        //                 crossAxisAlignment: CrossAxisAlignment.center,
        //                 children: [
        //                   Icon(
        //                     FontAwesomeIcons.circleCheck,
        //                     color: lightGradient,
        //                     size: height(context) * 0.2,
        //                   ),
        //                   30.height,
        //                   Text(
        //                     userLang.isAr
        //                         ? "تم الدفع بنجاح"
        //                         : "Payment Successfull",
        //                     style: GoogleFonts.readexPro(
        //                         fontSize: 20,
        //                         fontWeight: FontWeight.bold,
        //                         color: darkGradient),
        //                   ),
        //                   10.height,
        //                   Text(
        //                     "${userLang.isAr ? "مصدر رقم" : "Ref No"}: ${widget.id}",
        //                     style: GoogleFonts.readexPro(
        //                         fontSize: 17,
        //                         fontWeight: FontWeight.w500,
        //                         color: grey),
        //                   ),
        //                   10.height,
        //                   Text(
        //                     "${userLang.isAr ? "تاريخ" : "Date"}: ${DateFormat('dd MMM yyyy').format(DateTime.now())}",
        //                     style: GoogleFonts.readexPro(
        //                         fontSize: 17,
        //                         fontWeight: FontWeight.w500,
        //                         color: grey),
        //                   ),
        //                   10.height,
        //                   Text(
        //                     "${userLang.isAr ? "وقت" : "Time"}: ${DateFormat('h:mm a').format(DateTime.now())}",
        //                     style: GoogleFonts.readexPro(
        //                         fontSize: 17,
        //                         fontWeight: FontWeight.w500,
        //                         color: grey),
        //                   ),
        //                   40.height,
        //                   Align(
        //                     alignment: Alignment.center,
        //                     child: PrimaryButton(
        //                       text: userLang.isAr
        //                           ? "العودة إلى المنزل"
        //                           : "Back Home",
        //                       onTap: () => MyBooking().launch(context,
        //                           pageRouteAnimation:
        //                               PageRouteAnimation.Fade),
        //                     ),
        //                   ),
        //                 ],
        //               )
        //             : Column(
        //                 mainAxisAlignment: MainAxisAlignment.center,
        //                 crossAxisAlignment: CrossAxisAlignment.center,
        //                 children: [
        //                   Icon(
        //                     FontAwesomeIcons.circleExclamation,
        //                     color: Colors.redAccent,
        //                     size: height(context) * 0.2,
        //                   ),
        //                   30.height,
        //                   Text(
        //                     userLang.isAr
        //                         ? "الدفع غير ناجح"
        //                         : "Payment Unsuccessfull",
        //                     style: GoogleFonts.readexPro(
        //                         fontSize: 20,
        //                         fontWeight: FontWeight.bold,
        //                         color: darkGradient),
        //                   ),
        //                   40.height,
        //                   Align(
        //                     alignment: Alignment.center,
        //                     child: PrimaryButton(
        //                       text: userLang.isAr
        //                           ? "العودة إلى المنزل"
        //                           : "Back Home",
        //                       onTap: () => const RootPage().launch(context,
        //                           pageRouteAnimation:
        //                               PageRouteAnimation.Fade),
        //                     ),
        //                   ),
        //                 ],
        //               )),
        //   ),

        );
  }
}
