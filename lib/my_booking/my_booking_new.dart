// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:animate_do/animate_do.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:nb_utils/nb_utils.dart';

import 'package:wype_user/auth/login_page.dart';
import 'package:wype_user/booking/test.dart';
import 'package:wype_user/common/appbar.dart';
import 'package:wype_user/common/my_booking.dart';
import 'package:wype_user/constants.dart';
import 'package:wype_user/select_slot/select_slot.dart';
import 'package:wype_user/services/firebase_services.dart';

class MyBooking extends StatefulWidget {
  String? address;
  MyBooking({
    Key? key,
    this.address,
  }) : super(key: key);

  @override
  State<MyBooking> createState() => _MyBookingState();
}

class _MyBookingState extends State<MyBooking> {
  FirebaseService firebaseService = FirebaseService();
  List<Map<String, dynamic>> displayedBookingData = [];
  bool isSelected = false;
  bool isSelectedAll = false;
  bool isSelectedOngoing = false;
  bool isSelectedPast = false;
  Future<void> fetchData() async {
    if (isSelectedAll) {
      displayedBookingData = await firebaseService.getBookingData();
    } else if (isSelectedPast) {
      displayedBookingData = await firebaseService.closeBookingData();
    }
    setState(() {}); // Update the UI with fetched data
  }

  @override
  void initState() {
    // TODO: implement initState
    fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return FadeIn(
        child: SafeArea(
      child: Scaffold(
        // appBar: commonAppbar(widget.address.toString()),
        body: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 15,
          ),
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Row(
                  //   children: [
                  //     FaIcon(
                  //       Icons.pin_drop_outlined,
                  //       color: Utils().lightBlue,
                  //       size: 40,
                  //     ),
                  //     Column(
                  //       crossAxisAlignment: CrossAxisAlignment.start,
                  //       children: [
                  //         Text(
                  //           widget.address.toString() ??
                  //               bookingDetail!.address.toString(),
                  //           style: myFont28_600,
                  //         ),
                  //       ],
                  //     ),
                  //   ],
                  // ),
                  20.height,
                  const Divider(),
                  Text(
                    'Bookings',
                    style: myFont28_600.copyWith(fontSize: 28),
                  ),
                  10.height,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      InkWell(
                        splashColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        onTap: () {
                          setState(() {
                            isSelectedAll = true;
                            isSelectedOngoing = false;
                            isSelectedPast = false;
                          });
                        },
                        child: BookingContainer(
                          textColor: isSelectedAll ? white : gray,
                          title: 'All Booking',
                          color: isSelectedAll ? darkGradient : white,
                          borderColor: gray,
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          setState(() {
                            isSelectedAll = false;
                            isSelectedOngoing = true;
                            isSelectedPast = false;
                          });
                        },
                        child: BookingContainer(
                          textColor: isSelectedOngoing ? white : gray,
                          title: 'Ongoing',
                          color: isSelectedOngoing ? darkGradient : white,
                          borderColor: gray,
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          setState(() {
                            isSelectedAll = false;
                            isSelectedOngoing = false;
                            isSelectedPast = true;
                          });
                        },
                        child: BookingContainer(
                          textColor: isSelectedPast ? white : gray,
                          title: 'Past',
                          color: isSelectedPast ? darkGradient : white,
                          borderColor: gray,
                        ),
                      ),
                    ],
                  ),
                  16.height,
                  FutureBuilder(
                    future: isSelectedPast
                        ? firebaseService.closeBookingData()
                        : firebaseService.getBookingData(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                          child: CircularProgressIndicator.adaptive(),
                        );
                      } else if (snapshot.hasError) {
                        return Center(child: Text('Error: ${snapshot.error}'));
                      }
                      final bookings = snapshot.data ?? [];
                      if (bookings.isEmpty && isSelectedPast) {
                        // Show "No Data" message for the "Past" tab
                        return const Center(
                          child: Text(
                            'No Past Bookings', // Customize the message
                            style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey), // Customize the style
                          ),
                        );
                      } else {
                        displayedBookingData = snapshot.data!;
                        return ListView.separated(
                          separatorBuilder: (context, index) =>
                              const SizedBox(height: 18),
                          physics: const ScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: snapshot.data!.length,
                          itemBuilder: (context, index) {
                            final booking = bookings[index];
                            final slotDateData = (booking['slotDate'] as List?);

                            if (slotDateData == null || slotDateData.isEmpty) {
                              return const SizedBox
                                  .shrink(); // Return an empty widget if slotDateData is empty or null
                            }

                            return ListView.builder(
                              physics: const ScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: slotDateData.length,
                              itemBuilder: (context, slotIndex) {
                                final slot = slotDateData[slotIndex];

                                // Check if slot['dates'] is not null and not empty
                                if (slot['dates'] == null ||
                                    slot['dates'].isEmpty) {
                                  return const SizedBox
                                      .shrink(); // Skip this slot and return an empty widget
                                }
                                // Convert the timestamp to a DateTime object
                                final formattedDates =
                                    slot['dates'].map((timestamp) {
                                  final dateTime =
                                      DateTime.fromMillisecondsSinceEpoch(
                                              timestamp.seconds * 1000)
                                          .toLocal();
                                  return DateFormat('yyyy-MM-dd')
                                      .format(dateTime);
                                }).join(', ');
                                return Column(
                                  children: [
                                    BookingBuilder(
                                      carImg: bookCar,
                                      btnName: 'reschedule',
                                      carName: booking['vehicle']['company'],
                                      carNumber: booking['vehicle']
                                              ['number_plate'] ??
                                          'N/A',
                                      date:
                                          formattedDates, // Display slotDate date
                                      modelNumber: booking['vehicle']['model'],
                                      onTap: () {
                                        // Navigation code here
                                      },
                                      subscriptionName:
                                          booking['subscriptionName'],
                                      status: isSelectedOngoing
                                          ? 'on going'
                                          : isSelectedPast
                                              ? 'closed'
                                              : 'upcoming',
                                      time: "TIME : ${slot['slot']['startTime']}" ??
                                          'N/A', // Display slotData startTime

                                      widget: isSelectedOngoing ||
                                              isSelectedPast
                                          ? Container()
                                          : SizedBox(
                                              width: double.infinity,
                                              child: ElevatedButton(
                                                  onPressed: () {
                                                    _showEditDialog(
                                                        context, booking, slot);
                                                  },
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                          surfaceTintColor:
                                                              white,
                                                          shape:
                                                              RoundedRectangleBorder(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              30),
                                                                  side:
                                                                      BorderSide(
                                                                    color: Utils()
                                                                        .lightBlue,
                                                                  ))),
                                                  child: Text(
                                                    'reschedule'.toUpperCase(),
                                                    style:
                                                        myFont28_600.copyWith(
                                                            color: Utils()
                                                                .lightBlue),
                                                  )),
                                            ),
                                    ),
                                    20.height,
                                  ],
                                );
                              },
                            );
                          },
                        );
                      }
                    },
                  ),

                  20.height,
                ],
              ),
            ),
          ),
        ),
      ),
    ));
  }

  void _showEditDialog(BuildContext context, Map<String, dynamic> booking,
      Map<String, dynamic> slot) {
    final TextEditingController carNameController =
        TextEditingController(text: booking['vehicle']['company']);
    final TextEditingController carNumberController =
        TextEditingController(text: booking['vehicle']['number_plate']);
    final TextEditingController modelNumberController =
        TextEditingController(text: booking['vehicle']['model']);
    final TextEditingController subscriptionNameController =
        TextEditingController(text: booking['subscriptionName']);
    final TextEditingController timeController =
        TextEditingController(text: slot['slot']['startTime']);

    final DateTime initialDate =
        DateTime.fromMillisecondsSinceEpoch(slot['dates'][0].seconds * 1000)
            .toLocal();
    final TextEditingController dateController = TextEditingController(
        text: DateFormat('yyyy-MM-dd').format(initialDate));

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Edit Booking'),
          content: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                TextField(
                  controller: carNameController,
                  decoration: const InputDecoration(labelText: 'Car Name'),
                ),
                TextField(
                  controller: carNumberController,
                  decoration: const InputDecoration(labelText: 'Car Number'),
                ),
                TextField(
                  controller: modelNumberController,
                  decoration: const InputDecoration(labelText: 'Model Number'),
                ),
                TextField(
                  controller: subscriptionNameController,
                  decoration:
                      const InputDecoration(labelText: 'Subscription Name'),
                ),
                TextField(
                  controller: timeController,
                  decoration: const InputDecoration(labelText: 'Time'),
                ),
                TextField(
                  controller: dateController,
                  readOnly: true,
                  decoration: const InputDecoration(labelText: 'Date'),
                  onTap: () async {
                    DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDate: initialDate,
                      firstDate:
                          DateTime.now(), // Set the range for the date picker
                      lastDate: DateTime(2101),
                    );

                    if (pickedDate != null) {
                      dateController.text =
                          DateFormat('yyyy-MM-dd').format(pickedDate);
                    }
                  },
                ),
              ],
            ),
          ),
          actions: <Widget>[
            ElevatedButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            ElevatedButton(
              child: const Text('Save'),
              onPressed: () {
                firebaseService.updateBookingInFirebase(
                    booking['bookingID'],
                    carNameController.text,
                    carNumberController.text,
                    modelNumberController.text,
                    subscriptionNameController.text,
                    timeController.text,
                    dateController.text);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

}
