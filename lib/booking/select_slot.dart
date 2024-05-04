import 'package:animate_do/animate_do.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';
import 'package:wype_user/booking/dibsy_webview.dart';
import 'package:wype_user/booking/payment_options_screen.dart';
import 'package:wype_user/booking/payment_response.dart';
import 'package:wype_user/common/appbar.dart';
import 'package:wype_user/model/booking.dart';
import 'package:wype_user/model/dibsy_res.dart';
import 'package:wype_user/model/promo_code_model.dart';
import 'package:wype_user/model/shift_model.dart';
import 'package:wype_user/provider/language.dart';
import 'package:wype_user/services/firebase_services.dart';
import 'package:wype_user/services/location_services.dart';
import 'package:wype_user/services/payment_services.dart';

import '../common/primary_button.dart';
import '../constants.dart';

class SelectSlot extends StatefulWidget {
  // LatLng coordinates;
  String address;
  int selectedVehicleIndex;
  int selectedPackageIndex;
  var price;
  String? washCount;
  Services? promoCode;
  // List<String> addService;
  // List<String> removeService;
  // String comments;
  bool saveLocation;

  SelectSlot(
      {super.key,
      required this.address,
      // required this.coordinates,
      required this.price,
      required this.selectedPackageIndex,
      required this.selectedVehicleIndex,
      this.washCount,
      this.promoCode,
      // required this.addService,
      // required this.removeService,
      // required this.comments,
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
  bool isSelectedBorderColor = false;
  int? selectedWashTimeIndex;
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
  }

  Future<List<ShiftModel>>? shiftData;
  @override
  void initState() {
    // TODO: implement initState
    shiftData = fetchTimeSlot();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var userLang = Provider.of<UserLang>(context, listen: true);

    return Scaffold(
      appBar: commonAppbar('Select Slot'),
      backgroundColor: white,
      body: FadeIn(
        child: ListView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 20),
          children: [
            SizedBox(
              height: height(context) * 0.03,
            ),
            Row(
              children: [
                Text(
                  'Wash 1 :',
                  style: myFont28_600.copyWith(color: lightGradient),
                ),
                Text(
                  ' Date & Time',
                  style: myFont28_600.copyWith(),
                )
              ],
            ),
            10.height,
            // Row(
            //   children: [
            //     InkWell(
            //       borderRadius: BorderRadius.circular(20),
            //       onTap: () => popNav(context),
            //       child: Icon(
            //         Icons.chevron_left,
            //         size: 29,
            //         color: lightGradient,
            //       ),
            //     ),
            //     10.width,
            //     Text(
            //       userLang.isAr ? "فتحة الكتاب" : "Book Slot",
            //       style: GoogleFonts.readexPro(
            //           fontSize: 18,
            //           fontWeight: FontWeight.bold,
            //           color: lightGradient),
            //     ),
            //   ],
            // ),

            InkWell(
              borderRadius: BorderRadius.circular(20),
              onTap: () => selectDate(context),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: gray),
                ),
                child: Row(
                  children: [
                    Text(
                        selectedDate == null
                            ? userLang.isAr
                                ? "تاريخ"
                                : "Date"
                            : "${selectedDate!.day}-${selectedDate!.month}-${selectedDate!.year}",
                        style: myFont500.copyWith(fontSize: 17, color: gray)),
                    const Spacer(),
                    const Icon(
                      CupertinoIcons.calendar,
                      color: grey,
                    ),
                  ],
                ),
              ),
            ),

            15.height,
            Text('Available Slot on this Date', style: myFont28_600),
            10.height,

            FutureBuilder<List<ShiftModel>>(
              future: shiftData,
              builder: (context, snapshot) {
                log(selectedDate);
                List<ShiftModel> shift = snapshot.data ?? [];
                if (snapshot.hasData && snapshot.data != null) {
                  return SizedBox(
                    height: 500,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: GridView.builder(
                        physics: const ScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: shift.length,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          childAspectRatio: 3,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10,
                          crossAxisCount: 2, // number of items in each row
                        ),
                        itemBuilder: (context, index) {
                          var data = shift[index];
                          return InkWell(
                            splashColor: Colors.transparent,
                            highlightColor: Colors.transparent,
                            onTap: () {
                              selectedWashTimeIndex = index;

                              setState(() {});
                              log(selectedWashTimeIndex);
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                      color: selectedWashTimeIndex == index
                                          ? Utils().lightBlue
                                          : gray,
                                      width: selectedWashTimeIndex == index
                                          ? 2
                                          : 0)),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 0, vertical: 0),
                                child: Center(
                                    child: Text(
                                  "${data.startTime} - ${data.endTime}",
                                  style: myFont28_600,
                                )),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  );
                } else if (snapshot.hasError) {
                  return Text("error ${snapshot.error}");
                }
                return const Center(
                  child: CircularProgressIndicator.adaptive(),
                );
              },
            ),
            LocationService().currentAddress == null
                ? Container()
                : Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 15, vertical: 15),
                        child: Row(
                          children: [
                            const FaIcon(
                              Icons.pin_drop_outlined,
                              size: 30,
                              color: skyBlue,
                            ),
                            Text(widget.address,
                                textAlign: TextAlign.left,
                                style: myFont500.copyWith(
                                    fontWeight: FontWeight.w600)),
                            const Spacer(),
                            Text(
                              'change'.toUpperCase(),
                              style:
                                  myFont28_600.copyWith(color: Utils().skyBlue),
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
                  if (LocationService().currentAddress == null) {
                    PaymentOptions(
                      selectedSlotIndex: selectedWashTimeIndex!,
                      address: widget.address,
                      price: widget.price,
                      selectedPackageIndex: widget.selectedPackageIndex,
                      selectedVehicleIndex: widget.selectedVehicleIndex,
                      washCount: widget.washCount,
                      selectedDate: selectedDate,
                    ).launch(context,
                        pageRouteAnimation: PageRouteAnimation.Fade);
                    // AddVehiclePage(
                    //   saveLocation: true,
                    //   promoCode: widget.promoCode,
                    //   isFromHome: false,
                    //   coordinates: currentCoordinates,
                    //   address:
                    //       "${currentAddress!.name}, ${currentAddress!.administrativeArea}\n${currentAddress!.country}, ${currentAddress!.postalCode}",
                    // ).launch(context,
                    //     pageRouteAnimation: PageRouteAnimation.Fade);
                  }
                  log(selectedDate);
                },
              ),
            ),
            const SizedBox(
              height: 30,
            )
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
