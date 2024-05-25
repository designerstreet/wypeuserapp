import 'package:animate_do/animate_do.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
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
import 'package:wype_user/model/employee_model.dart';
import 'package:wype_user/model/promo_code_model.dart';
import 'package:wype_user/model/shift_model.dart';
import 'package:wype_user/provider/language.dart';
import 'package:wype_user/services/firebase_services.dart';
import 'package:wype_user/services/location_services.dart';
import 'package:wype_user/services/payment_services.dart';

import '../common/primary_button.dart';
import '../constants.dart';

class SelectSlot extends StatefulWidget {
  String subscriptionName;
  String? dueration;
  LatLng? coordinates;
  var serviceName;
  var serviceCost;
  int? selectedServiceIndex;
  int? serviceQuantity;
  String? noOfWash;
  String? carName;
  String? carModel;
  String? address;
  int? selectedVehicleIndex;
  int? selectedPackageIndex;
  var packageName;
  var price;
  String? washCount;
  Services? promoCode;
  // List<String> addService;
  // List<String> removeService;
  // String comments;
  bool? saveLocation;

  SelectSlot(
      {super.key,
      required this.subscriptionName,
      this.coordinates,
      this.dueration,
      this.serviceName,
      this.serviceCost,
      this.serviceQuantity,
      this.selectedServiceIndex,
      this.address,
      this.packageName,
      this.noOfWash,
      this.price,
      this.selectedPackageIndex,
      this.selectedVehicleIndex,
      this.washCount,
      this.promoCode,
      this.saveLocation,
      this.carName,
      this.carModel});

  @override
  State<SelectSlot> createState() => _SelectSlotState();
}

class _SelectSlotState extends State<SelectSlot> {
  DateTime currentDateTime = DateTime.now();
  int? selectedDateIndex; // This will keep track of which date is selected
  DateTime? selectedDateTime; // This will keep track of the selected DateTime
  int? selectedSlotIndex; // This will keep track of the selected slot

  String? pickedTime;
  FirebaseService firebaseService = FirebaseService();
  bool isLoading = false;
  bool isCard = true;
  bool isWallet = false;
  bool isSelectedBorderColor = false;
  Future<List<ShiftModel>>? shiftData;
  List<EmployeeModel> employeeList = [];
  // final List<Map<String, String>> totalSlot = [];
  List<Map<String, dynamic>> washDate = [];
  int due = 1;
  final filteredList = [].obs;
  setLoader(bool val) {
    isLoading = val;
    setState(() {});
  }

  // void filterTime() {
  //   final now = DateTime.now();
  //   final currentHour = now.hour;

  //   filteredList.value = timeList.where((time) {
  //     final parts =
  //         time.split(' '); // Split on space (to separate hours and AM/PM)
  //     final hourString = parts[0].split(':')[0]; // Extract hour part
  //     var hour = int.parse(hourString);

  //     // Adjust hour for PM (12-hour clock)
  //     if (parts.length > 1 && parts[1].toLowerCase() == 'pm' && hour != 12) {
  //       hour += 12;
  //     }

  //     // Check if the time slot is after the current time
  //     return hour >= currentHour;
  //   }).toList();
  //   // Trigger a rebuild after filtering
  // }
  final List<Map<String, String>> totalSlot = [];
  slotLenth() {
    int slotLenth = widget.selectedPackageIndex == 0
        ? 4
        : widget.selectedPackageIndex == 1
            ? 8
            : widget.selectedPackageIndex == 2
                ? 12
                : 1;
    for (var i = 0; i < slotLenth; i++) {
      washDate.add({"dates": [], "slot": ''});
    }
  }

  slotTotal(List<Map<String, String>> totalSlot) async {
    totalSlot.clear();
    List<String> parts = widget.dueration!.split(':');
    if (parts.isNotEmpty && parts.isNotEmpty) {
      log("partsss$parts");
      int hours = int.parse((parts.first.toString().trim() ?? "0").toString());
      int minutes = int.parse((parts.last.toString().trim() ?? "0").toString());

      int totalMinutes = (hours * 60) + minutes;
      due = totalMinutes;
    }

    for (var element in firebaseService.employeeList) {
      var shifts = element;
      log("===xvxvxxvx$shifts");
      var splitTime = shifts.shift!.split('TO');

      if (splitTime.isNotEmpty && splitTime.length > 1) {
        var start = splitTime[0].toString().trim();
        var end = splitTime[1].toString().trim();

        // Create a DateFormat object
        DateFormat dateFormat = DateFormat("h:mm a");

        DateTime startDateTime = dateFormat.parse(start);
        DateTime endDateTime = dateFormat.parse(end);

        Duration duration = endDateTime.difference(startDateTime);
        int totalDurationInMinutes = duration.inMinutes;

        int slotCount = totalDurationInMinutes ~/ due;

        for (int i = 0; i < slotCount; i++) {
          DateTime slotStartTime =
              startDateTime.add(Duration(minutes: due * i));
          DateTime slotEndTime = slotStartTime.add(Duration(minutes: due));

          totalSlot.add({
            "startTime": dateFormat.format(slotStartTime),
            "endTime": dateFormat.format(slotEndTime),
            "due": due.toString()
          });
        }
        log(totalSlot);
        log("Total slots created: $totalSlot");
      } else {
        log("Invalid shift time format");
      }
      setState(() {});
    }
  }

  void selectDate(BuildContext context, int index) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: currentDateTime,
      firstDate: currentDateTime,
      lastDate: currentDateTime.add(GetNumUtils(30).days),
    );

    if (picked != null) {
      slotTotal(totalSlot);
      setState(() {
        selectedDateIndex = index;
        selectedDateTime = picked;
        washDate[index]['dates'] = [];
        washDate[index]['dates'].add(picked);
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    // shiftData = firebaseService.fetchTimeSlot();
    firebaseService.getEmployee();

    slotLenth();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var userLang = Provider.of<UserLang>(context, listen: true);
    // log(" =>> package name, ${widget.packageName ?? -1}");
    // log(" =>> package index, ${widget.selectedPackageIndex}");
    // log(' =>> selected vehicle index, ${widget.noOfWash}');
    // log(' =>> total price, ${widget.price}');
    log(' =>> due from slot, ${widget.dueration}');
    log(' =>> sub name, ${widget.subscriptionName}');
    log(' =>> lat long slot, ${widget.coordinates}');
    final now = DateTime.now(); // Get current time
    final formattedNow = DateFormat.Hm().format(now); //
    return Scaffold(
      appBar: commonAppbar(userLang.isAr ? "فتحة الكتاب" : "Book Slot"),
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
                                washDate[index]['dates'].isEmpty
                                    ? "Date"
                                    : washDate[index]['dates'].map((date) {
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
                    washDate[index]['dates'].isNotEmpty
                        ? Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: GridView.builder(
                              physics: const ScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: totalSlot.length,
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                childAspectRatio: 3,
                                crossAxisSpacing: 10,
                                mainAxisSpacing: 10,
                                crossAxisCount: 2,
                              ),
                              itemBuilder: (context, slotIndex) {
                                // Retrieve the slot currently being built

                                // Calculate selectedDate based on washDate[index]['dates']
                                DateTime? selectedDate =
                                    washDate[index]['dates'].isNotEmpty
                                        ? washDate[index]['dates'][0]
                                        : null;
                                var slot = totalSlot[slotIndex];

                                bool isCurrentOrFutureSlot = false;
                                bool isToday = false;
                                if (selectedDate != null &&
                                    selectedDate.year == now.year &&
                                    selectedDate.month == now.month &&
                                    selectedDate.day == now.day) {
                                  isToday = true;
                                }
                                // Parse start and end times from the slot data
                                DateTime startTime = DateFormat("h:mm a")
                                    .parse(slot["startTime"] ?? "");
                                DateTime endTime = DateFormat("h:mm a")
                                    .parse(slot["endTime"] ?? "");

                                // Converting time-only objects into DateTime objects at today's date (if desired)

                                if (selectedDate != null) {
                                  startTime = DateTime(
                                    selectedDate.year,
                                    selectedDate.month,
                                    selectedDate.day,
                                    startTime.hour,
                                    startTime.minute,
                                  );
                                  endTime = DateTime(
                                    selectedDate.year,
                                    selectedDate.month,
                                    selectedDate.day,
                                    endTime.hour,
                                    endTime.minute,
                                  );
                                }

                                // Checking if the current time is before the end of the slot
                                if (startTime.isAfter(now) ||
                                    (startTime.isAtSameMomentAs(now))) {
                                  isCurrentOrFutureSlot =
                                      true; // Current or future slot
                                }

                                return InkWell(
                                  key: Key('time_$slotIndex'),
                                  splashColor: Colors.transparent,
                                  highlightColor: Colors.transparent,
                                  onTap: (!isToday && isCurrentOrFutureSlot)
                                      ? () {
                                          // Your code here for selecting the slot
                                          washDate[index]['slot'] = slotIndex;
                                          selectedSlotIndex = slotIndex;
                                          setState(() {});
                                          log(washDate[index]['slot']
                                              .toString());
                                        }
                                      : isToday && isCurrentOrFutureSlot
                                          ? () {
                                              // Your code here for selecting the slot (if today and before endTime)
                                              washDate[index]['slot'] =
                                                  slotIndex;
                                              selectedSlotIndex = slotIndex;
                                              setState(() {});
                                              log(washDate[index]['slot']
                                                  .toString());
                                            }
                                          : null,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: isCurrentOrFutureSlot
                                          ? Colors.white
                                          : Utils().softBlue,
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(
                                        color: isCurrentOrFutureSlot
                                            ? (washDate[index]['slot'] ==
                                                    slotIndex
                                                ? Utils().lightBlue
                                                : Colors.grey)
                                            : Colors.grey,
                                        width: isCurrentOrFutureSlot &&
                                                (washDate[index]['slot'] ==
                                                    slotIndex)
                                            ? 2
                                            : 0,
                                      ),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 0, vertical: 0),
                                      child: Center(
                                        child: Text(
                                          isCurrentOrFutureSlot
                                              ? "${slot["startTime"] ?? ""} TO ${slot["endTime"] ?? ""}"
                                              : 'No slot for today',
                                          style:
                                              myFont28_600, // Ensure this style is defined in your project
                                        ),
                                      ),
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
                      Text(widget.address ?? 'N/A',
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
                      log(washDate);
                      if (selectedDateIndex != null &&
                          selectedSlotIndex != null) {
                        for (int i = 0; i < washDate.length; i++) {
                          String slotString =
                              washDate[i]['slot'].toString().trim();
                          if (slotString.isNotEmpty &&
                              int.tryParse(slotString) != null) {
                            int slotIndex = int.parse(slotString);
                            washDate[i]['slot'] = totalSlot[slotIndex];
                          } else {
                            washDate[i]['slot'] = '';
                          }
                        }
                        PaymentOptions(
                          subscriptionName: widget.subscriptionName,
                          coordinates: widget.coordinates!,
                          serviceCost: widget.serviceCost,
                          serviceName: widget.serviceName,
                          carName: widget.carName,
                          carModel: widget.carModel,
                          slotDate: washDate,
                          packageName: widget.packageName,
                          // selectedSlotIndex: selectedSlotIndex,
                          selectedDate: selectedDateTime,
                          address: widget.address!,
                          price: widget.price,
                          selectedPackageIndex: widget.selectedPackageIndex!,
                          selectedVehicleIndex: widget.selectedVehicleIndex!,
                          washCount: widget.washCount,
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
                          washDate == null
                              ? 'please select a date'
                              : 'please select a time',
                        );
                      }
                      // log('Selected Date: $selectedDates');
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
