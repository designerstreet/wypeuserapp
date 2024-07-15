import 'package:animate_do/animate_do.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';
import 'package:wype_user/booking/dibsy_webview.dart';
import 'package:wype_user/booking/payment_response.dart';
import 'package:wype_user/model/booking.dart';
import 'package:wype_user/model/dibsy_res.dart';
import 'package:wype_user/model/promo_code_model.dart';
import 'package:wype_user/provider/language.dart';
import 'package:wype_user/services/firebase_services.dart';
import 'package:wype_user/services/payment_services.dart';

import '../common/primary_button.dart';
import '../constants.dart';

class SelectSlot extends StatefulWidget {
  LatLng coordinates;
  String address;
  int selectedVehicleIndex;
  int selectedPackageIndex;
  num price;
  int washCount;
  Services? promoCode;
  List<String> addService;
  List<String> removeService;
  String comments;
  bool saveLocation;

  SelectSlot(
      {super.key,
      required this.address,
      required this.coordinates,
      required this.price,
      required this.selectedPackageIndex,
      required this.selectedVehicleIndex,
      required this.washCount,
      this.promoCode,
      required this.addService,
      required this.removeService,
      required this.comments,
      required this.saveLocation});

  @override
  State<SelectSlot> createState() => _SelectSlotState();
}

class _SelectSlotState extends State<SelectSlot> {
  DateTime currentDateTime = DateTime.now();
  DateTime? selectedDate;
  String? pickedTime;
  FirebaseService firebaseService = FirebaseService();
  bool isLoading = false;
  bool isCard = true;
  bool isWallet = false;

  setLoader(bool val) {
    isLoading = val;
    setState(() {});
  }

  void selectDate(BuildContext context) async {
    await showDatePicker(
      context: context,
      initialDate: selectedDate ?? currentDateTime,
      firstDate: currentDateTime,
      lastDate: currentDateTime.add(30.days),
      builder: (_, child) {
        return Theme(
          data: ThemeData.dark(useMaterial3: true),
          child: child!,
        );
      },
    ).then((date) => {
          if (date != null) {selectedDate = date, setState(() {})}
        });
  }

  void selectTime(BuildContext context) async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          child: SizedBox(
            width: 200,
            height: 200,
            child: CupertinoPicker(
              itemExtent: 33,
              onSelectedItemChanged: (value) {
                if (timings[value] != "Unavailable") {
                  pickedTime = timings[value];
                } else {
                  pickedTime = null;
                }
                setState(() {});
              },
              children: List.generate(
                timings.length,
                (index) => Text(timings[index]),
              ),
            ),
          ),
        );
      },
    );

    // showTimePicker(
    //   context: context,
    //   initialTime: pickedTime ?? TimeOfDay.now(),
    //   builder: (_, child) {
    //     return Theme(
    //       data: ThemeData.dark(useMaterial3: true),
    //       child: child!,
    //     );
    //   },
    // ).then((time) => {
    //       if (time != null) {pickedTime = time, setState(() {})}
    //     });
  }

  @override
  Widget build(BuildContext context) {
    var userLang = Provider.of<UserLang>(context, listen: true);

    return Scaffold(
      backgroundColor: white,
      body: FadeIn(
        child: ListView(
          physics: BouncingScrollPhysics(),
          padding: EdgeInsets.symmetric(horizontal: 20),
          children: [
            SizedBox(
              height: height(context) * 0.06,
            ),
            Row(
              children: [
                InkWell(
                  borderRadius: BorderRadius.circular(20),
                  onTap: () => popNav(context),
                  child: Icon(
                    Icons.chevron_left,
                    size: 29,
                    color: lightGradient,
                  ),
                ),
                10.width,
                Text(
                  userLang.isAr ? "فتحة الكتاب" : "Book Slot",
                  style: GoogleFonts.readexPro(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: lightGradient),
                ),
              ],
            ),
            30.height,
            InkWell(
              borderRadius: BorderRadius.circular(20),
              onTap: () => selectDate(context),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: darkGradient),
                ),
                child: Row(
                  children: [
                    Text(
                      selectedDate == null
                          ? userLang.isAr
                              ? "تاريخ"
                              : "Date"
                          : "${selectedDate!.day}-${selectedDate!.month}-${selectedDate!.year}",
                      style: GoogleFonts.readexPro(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: grey),
                    ),
                    Spacer(),
                    Icon(
                      FontAwesomeIcons.calendar,
                      color: grey,
                    )
                  ],
                ),
              ),
            ),
            15.height,
            InkWell(
              borderRadius: BorderRadius.circular(20),
              onTap: () => selectTime(context),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: darkGradient),
                ),
                child: Row(
                  children: [
                    Text(
                      pickedTime == null
                          ? userLang.isAr
                              ? "وقت"
                              : "Time"
                          : "$pickedTime",
                      style: GoogleFonts.readexPro(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: grey),
                    ),
                    Spacer(),
                    Icon(
                      FontAwesomeIcons.clock,
                      color: grey,
                    )
                  ],
                ),
              ),
            ),
            25.height,
            Text(
              userLang.isAr ? "حدد العنوان" : "Select Address",
              style: GoogleFonts.readexPro(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: lightGradient),
            ),
            20.height,
            Container(
              padding: EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: darkGradient,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: darkGradient),
              ),
              child: Text(
                widget.address,
                style: GoogleFonts.readexPro(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.white),
              ),
            ),
            25.height,
            Text(
              userLang.isAr ? "خيارات الدفع" : "Payment Options",
              style: GoogleFonts.readexPro(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: lightGradient),
            ),
            15.height,
            InkWell(
              borderRadius: BorderRadius.circular(20),
              onTap: () {
                isCard = true;
                isWallet = false;
                setState(() {});
              },
              child: Container(
                height: height(context) * 0.07,
                decoration: BoxDecoration(
                  color: isCard ? darkGradient : Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: darkGradient),
                ),
                padding: EdgeInsets.all(15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      FontAwesomeIcons.creditCard,
                      color: isCard ? Colors.white : darkGradient,
                    ),
                    10.width,
                    Text(
                      userLang.isAr ? "بطاقة" : "Card",
                      style: GoogleFonts.readexPro(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: lightGradient),
                    ),
                  ],
                ),
              ),
            ),
            15.height,
            InkWell(
              borderRadius: BorderRadius.circular(20),
              onTap: () {
                if ((userData?.wallet ?? 0) >= widget.price) {
                  isCard = false;
                  isWallet = true;
                  setState(() {});
                } else {
                  toast(
                      userLang.isAr ? "رصيد غير كاف" : "Insufficient Balance");
                }
              },
              child: Container(
                height: height(context) * 0.07,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: isWallet ? darkGradient : Colors.white,
                  border: Border.all(color: darkGradient),
                ),
                padding: EdgeInsets.all(15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      FontAwesomeIcons.creditCard,
                      color: isWallet ? Colors.white : darkGradient,
                    ),
                    10.width,
                    Text(
                      userLang.isAr ? "محفظة" : "Wallet",
                      style: GoogleFonts.readexPro(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: lightGradient),
                    ),
                  ],
                ),
              ),
            ),
            10.height,
            Center(
              child: Text(
                "${userLang.isAr ? "رصيد المحفظة: " : "Wallet Balance: "} ${userData?.wallet}",
                style: GoogleFonts.readexPro(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey),
              ),
            ),
            20.height,
            Row(
              children: [
                Text(
                  userLang.isAr ? "المبلغ الإجمالي" : "Total Amount",
                  style: GoogleFonts.readexPro(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey),
                ),
                Spacer(),
                Text(
                  "${widget.price}",
                  style: GoogleFonts.readexPro(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey),
                ),
              ],
            ),
            Row(
              children: [
                Text(
                  userLang.isAr
                      ? "تم تطبيق الرمز الترويجي"
                      : "Applied Promo Code",
                  style: GoogleFonts.readexPro(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey),
                ),
                Spacer(),
                Text(
                  widget.promoCode == null ? "-" : "${widget.promoCode?.name}",
                  style: GoogleFonts.readexPro(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey),
                ),
              ],
            ),
            Divider(),
            Row(
              children: [
                Text(
                  userLang.isAr ? "المبلغ الإجمالي الجديد" : "New Total Amount",
                  style: GoogleFonts.readexPro(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey),
                ),
                Spacer(),
                Text(
                  widget.promoCode == null
                      ? "${widget.price}"
                      : "${(widget.price - ((widget.promoCode?.price ?? 0) / 100) * widget.price).toStringAsFixed(2)}",
                  style: GoogleFonts.readexPro(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey),
                ),
              ],
            ),
            20.height,
            Align(
              alignment: Alignment.center,
              child: PrimaryButton(
                text: isLoading
                    ? loaderText
                    : "${userLang.isAr ? "يدفع" : "Pay"} QR "
                        "${widget.promoCode == null ? "${widget.price}" : (widget.price - ((widget.promoCode?.price ?? 0) / 100) * widget.price).toStringAsFixed(2)}",
                onTap: ()
                    // => navigation(context, PaymentResponse(), true),
                    async {
                  if (selectedDate == null || pickedTime == null) {
                    toast(userLang.isAr
                        ? "الرجاء تحديد التاريخ والوقت"
                        : "Please select Date and Time");
                  } else {
                    setLoader(true);
                    if (isWallet) {
                      num walletBalance = (userData?.wallet ?? 0) -
                          ((widget.promoCode == null)
                              ? widget.price
                              : (widget.price -
                                  ((widget.promoCode?.price ?? 0) / 100) *
                                      widget.price));
                      firebaseService.updateWallet(walletBalance).then(
                            (value) => navigation(
                                context,
                                PaymentResponse(
                                  id: "Wallet Payment",
                                  saveLocation: widget.saveLocation,
                                  booking: BookingModel(
                                      comments: widget.comments,
                                      addService: widget.addService,
                                      removeService: widget.removeService,
                                      latlong: LatLngModel(
                                          lat: widget.coordinates.latitude,
                                          long: widget.coordinates.longitude),
                                      address: widget.address,
                                      bookingStatus: "up_coming",
                                      serviceType: subscriptionPackage?[
                                                  widget.selectedPackageIndex]
                                              .name ??
                                          "N/A",
                                      userId: userData?.id ?? "",
                                      vehicle: userData!.vehicle![
                                          widget.selectedVehicleIndex],
                                      washCount: widget.washCount,
                                      washTimings:
                                          createTimestampFromDateAndTime(
                                              selectedDate.toString(),
                                              pickedTime!)),
                                  amount: widget.promoCode == null
                                      ? widget.price.toDouble()
                                      : (widget.price -
                                              ((widget.promoCode?.price ?? 0) /
                                                      100) *
                                                  widget.price)
                                          .toDouble(),
                                ),
                                true),
                          );
                    }
                    try {
                      PaymentModel? paymentRes = await createPayment(
                          widget.promoCode == null
                              ? widget.price.toDouble()
                              : (widget.price -
                                      ((widget.promoCode?.price ?? 0) / 100) *
                                          widget.price)
                                  .toDouble(),
                          subscriptionPackage?[widget.selectedPackageIndex]
                                  .name ??
                              "N/A");
                      setLoader(false);

                      if (paymentRes != null) {
                        navigation(
                            context,
                            DibsyWebview(
                              saveLocation: widget.saveLocation,
                              url: paymentRes.links!.checkout!.href!,
                              id: paymentRes.id!,
                              amount: widget.promoCode == null
                                  ? widget.price.toDouble()
                                  : (widget.price -
                                          ((widget.promoCode?.price ?? 0) /
                                                  100) *
                                              widget.price)
                                      .toDouble(),
                              booking: BookingModel(
                                  comments: widget.comments,
                                  addService: widget.addService,
                                  removeService: widget.removeService,
                                  latlong: LatLngModel(
                                      lat: widget.coordinates.latitude,
                                      long: widget.coordinates.longitude),
                                  address: widget.address,
                                  bookingStatus: "up_coming",
                                  serviceType: subscriptionPackage?[
                                              widget.selectedPackageIndex]
                                          .name ??
                                      "N/A",
                                  userId: userData?.id ?? "",
                                  vehicle: userData!
                                      .vehicle![widget.selectedVehicleIndex],
                                  washCount: widget.washCount,
                                  washTimings: createTimestampFromDateAndTime(
                                      selectedDate.toString(), pickedTime!)),
                            ),
                            true);
                      } else {
                        toast(userLang.isAr
                            ? "الرجاء معاودة المحاولة في وقت لاحق"
                            : "Please try again later");
                      }
                    } catch (e) {
                      print("Error: $e");
                      setLoader(false);
                    }
                  }
                },
              ),
            ),
            20.height,
          ],
        ),
      ),
    );
  }
}

Timestamp createTimestampFromDateAndTime(String date, String time) {
  String combinedDateTimeString = '${date.substring(0, 10)} $time';
  DateTime parsedDateTime =
      DateFormat("yyyy-MM-dd h:mm a").parse(combinedDateTimeString);
  Timestamp timestamp = Timestamp.fromDate(parsedDateTime);

  return timestamp;
}
