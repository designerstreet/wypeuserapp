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
  String washType;
  String? carName;
  String? carModel;
  String address;
  int selectedVehicleIndex;
  int selectedPackageIndex;
  var packageName;
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
      required this.packageName,
      required this.washType,
      // required this.coordinates,
      required this.price,
      required this.selectedPackageIndex,
      required this.selectedVehicleIndex,
      this.washCount,
      this.promoCode,
      // required this.addService,
      // required this.removeService,
      // required this.comments,
      required this.saveLocation,
      this.carName,
      this.carModel});

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

  List<String> filteredList = [];
  void filterTime() {
    final currentHour = int.parse(DateFormat('h').format(DateTime.now()));
    filteredList = timeList.where((time) {
      int timeHour = int.parse(time.split(':')[0]);
      setState(() {});
      return timeHour >= currentHour;
    }).toList();
  }

  List<DateTime> selectedDates = [];
  void selectDate(BuildContext context, int index) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? currentDateTime,
      firstDate: currentDateTime,
      lastDate: currentDateTime.add(30.days),
    );

    if (picked != null) {
      setState(() {
        if (selectedDates.contains(picked)) {
          selectedDates.remove(picked);
        } else {
          selectedDates.add(picked);
        }
      });
    }
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
    filterTime();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var userLang = Provider.of<UserLang>(context, listen: true);
    log(" =>> package name, ${widget.packageName ?? -1}");
    log(" =>> package index, ${widget.selectedPackageIndex}");
    log(' =>> selected vehicle index, ${widget.washType}');

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
// if(widget.washCount)

            ListView.builder(
              physics: const ScrollPhysics(),
              shrinkWrap: true,
              itemCount: widget.selectedPackageIndex == 0
                  ? 4
                  : widget.selectedPackageIndex == 1
                      ? 8
                      : widget.selectedPackageIndex == 2
                          ? 12
                          : 1,
              itemBuilder: (context, index) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          'Wash ${index + 1} :',
                          style: myFont28_600.copyWith(color: lightGradient),
                        ),
                        Text(
                          ' Date & Time',
                          style: myFont28_600.copyWith(),
                        )
                      ],
                    ),
                    10.height,
                    InkWell(
                      key: Key('date_$index'),
                      borderRadius: BorderRadius.circular(20),
                      onTap: () {
                        selectDate(context, index);
                        log(index.toString());
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 15, vertical: 15),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: gray),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                selectedDates.isEmpty
                                    ? "Date"
                                    : selectedDates.map((date) {
                                        return "${date.day}-${date.month}-${date.year}";
                                      }).join(", "),
                                overflow: TextOverflow.visible,
                                style: const TextStyle(
                                    fontSize: 17, color: Colors.grey),
                              ),
                            ),
                            const Spacer(),
                            const Icon(CupertinoIcons.calendar,
                                color: Colors.grey),
                          ],
                        ),
                      ),
                    ),
                    15.height,
                    Text('Available Slot on this Date', style: myFont28_600),
                    10.height,
                    selectedDates.isNotEmpty
                        ? filteredList.isEmpty
                            ? Center(
                                child: Text(
                                'No Slot Available',
                                style: myFont28_600,
                              ))
                            : Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: GridView.builder(
                                  physics: const ScrollPhysics(),
                                  shrinkWrap: true,
                                  itemCount: filteredList.length,
                                  gridDelegate:
                                      const SliverGridDelegateWithFixedCrossAxisCount(
                                    childAspectRatio: 3,
                                    crossAxisSpacing: 10,
                                    mainAxisSpacing: 10,
                                    crossAxisCount:
                                        2, // number of items in each row
                                  ),
                                  itemBuilder: (context, slotIndex) {
                                    return InkWell(
                                      key: Key('time_$index'),
                                      splashColor: Colors.transparent,
                                      highlightColor: Colors.transparent,
                                      onTap: () {
                                        selectedWashTimeIndex = slotIndex;

                                        setState(() {});
                                        log(selectedWashTimeIndex);
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            border: Border.all(
                                                color: selectedWashTimeIndex ==
                                                        slotIndex
                                                    ? Utils().lightBlue
                                                    : gray,
                                                width: selectedWashTimeIndex ==
                                                        slotIndex
                                                    ? 2
                                                    : 0)),
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 0, vertical: 0),
                                          child: Center(
                                              child: Text(
                                            filteredList[slotIndex],
                                            // "${data.startTime} - ${data.endTime}",
                                            style: myFont28_600,
                                          )),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              )
                        : Text(
                            '',
                            style: myFont28_600.copyWith(color: redColor),
                          ),
                  ],
                );
              },
            ),

            Column(
              // crossAxisAlignment: CrossAxisAlignment.end,
              // mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                  child: Row(
                    children: [
                      const FaIcon(
                        Icons.pin_drop_outlined,
                        size: 30,
                        color: skyBlue,
                      ),
                      Text(widget.address,
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
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: PrimaryButton(
                    text: 'Proceed to checkout',
                    onTap: () {
                      if (selectedDates.isNotEmpty &&
                          selectedWashTimeIndex != null) {
                        PaymentOptions(
                          carName: widget.carName,
                          carModel: widget.carModel,
                          slotDate: selectedDates,
                          packageName: widget.packageName,
                          selectedSlotIndex: selectedWashTimeIndex!,
                          address: widget.address,
                          price: widget.price,
                          selectedPackageIndex: widget.selectedPackageIndex,
                          selectedVehicleIndex: widget.selectedVehicleIndex,
                          washCount: widget.washCount,
                          selectedDate: 'Selected Date: $selectedDates',
                        ).launch(context,
                            pageRouteAnimation: PageRouteAnimation.Fade);
                        log(" =>> packagex name ${widget.packageName}");

                        // AddVehiclePage(
                        //   saveLocation: true,
                        //   promoCode: widget.promoCode,
                        //   isFromHome: false,
                        //   coordinates: currentCoordinates,
                        //   address:
                        //       "${currentAddress!.name}, ${currentAddress!.administrativeArea}\n${currentAddress!.country}, ${currentAddress!.postalCode}",
                        // ).launch(context,
                        //     pageRouteAnimation: PageRouteAnimation.Fade);
                      } else {
                        toast(
                          selectedDate == null
                              ? 'please select a date'
                              : 'please select a time',
                        );
                      }
                      log('Selected Date: $selectedDates');
                    },
                  ),
                ),
              ],
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
