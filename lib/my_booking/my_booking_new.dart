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
  bool isSelected = false;
  @override
  void initState() {
    // TODO: implement initState
    firebaseService.getBookingData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: FadeIn(
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
                Row(
                  children: [
                    FaIcon(
                      Icons.pin_drop_outlined,
                      color: Utils().lightBlue,
                      size: 40,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '',
                          style: myFont28_600,
                        ),
                      ],
                    ),
                  ],
                ),
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
                          isSelected = true;
                        });
                      },
                      child: BookingContainer(
                        textColor: isSelected ? white : gray,
                        title: 'All Booking',
                        color: isSelected ? darkGradient : white,
                        borderColor: gray,
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        setState(() {
                          isSelected = false;
                        });
                      },
                      child: BookingContainer(
                        textColor: isSelected ? white : gray,
                        title: 'Ongoing',
                        color: isSelected ? darkGradient : white,
                        borderColor: gray,
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        setState(() {
                          isSelected = false;
                        });
                      },
                      child: BookingContainer(
                        textColor: isSelected ? white : gray,
                        title: 'Past',
                        color: isSelected ? darkGradient : white,
                        borderColor: gray,
                      ),
                    ),
                  ],
                ),
                16.height,
                FutureBuilder(
                    future: firebaseService.getBookingData(),
                    builder: (context, snapshot) {
                      return snapshot.hasData
                          ? ListView.separated(
                              separatorBuilder: (context, index) =>
                                  const SizedBox(
                                height: 18,
                              ),
                              physics: const ScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: snapshot.data!.length,
                              itemBuilder: (context, index) {
                                final booking = snapshot.data![index];
                                final slotDateData =
                                    (booking['slotDate'] as List?);
                                List<String> formattedDates = [];
                                List<String> slotInfos = [];

                                if (slotDateData != null) {
                                  for (var slot in slotDateData) {
                                    if (slot is Map) {
                                      // Extract and format dates
                                      if (slot['dates'] is List &&
                                          slot['dates'].isNotEmpty) {
                                        final timestamp = slot['dates'][0];
                                        if (timestamp is Timestamp) {
                                          final dateTime = timestamp.toDate();
                                          formattedDates.add(
                                              DateFormat('yyyy-MM-dd')
                                                  .format(dateTime));
                                        }
                                      }

                                      // Extract slot information
                                      if (slot['slot'] != null &&
                                          slot['slot'].toString().isNotEmpty) {
                                        slotInfos.add(slot['slot'].toString());
                                      }
                                    }
                                  }
                                }
                                String formattedSlots = slotInfos.isNotEmpty
                                    ? slotInfos
                                        .join(',\n')
                                        .replaceAll(',', ',\n')
                                        .replaceAll('due', 'time')
                                        .replaceAllMapped('}', (match) => '')
                                        .replaceAllMapped('{', (match) => '')
                                    : "";
                                // formattedDates
                                //     .removeWhere((date) => date == '-');
                                // slotInfos.removeWhere((slot) => slot == '-');
                                return BookingBuilder(
                                    carImg: bookCar,
                                    btnName: 'reschedule',
                                    carName: snapshot.data![index]['vehicle']
                                        ['company'],
                                    carNumber: snapshot.data?[index]['vehicle']
                                            ['number_plate'] ??
                                        'N/A',
                                    date: formattedDates
                                        .join(',\n')
                                        .replaceAll(',', ''),

                                    // snapshot.data![index]['slotDate']
                                    //     .toString(),
                                    modelNumber: snapshot.data![index]
                                        ['vehicle']['model'],
                                    onTap: () {
                                      // SelectSlot().launch(context,
                                      //     pageRouteAnimation:
                                      //         PageRouteAnimation.Fade);
                                    },
                                    subscriptionName: snapshot.data![index]
                                        ['subscriptionName'],
                                    status: 'on going',
                                    time: formattedSlots
                                    // snapshot.data![index]['slotDate']['slot']
                                    //     .toString(),
                                    );
                              },
                            )
                          : const Center(
                              child: CircularProgressIndicator.adaptive(),
                            );
                    }),
                20.height,
              ],
            ),
          ),
        ),
      ),
    )));
  }
}
