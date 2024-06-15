import 'package:animate_do/animate_do.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:wype_user/common/appbar.dart';
import 'package:wype_user/constants.dart';
import 'package:wype_user/services/firebase_services.dart';
import 'package:wype_user/subscription_screens/add_address.dart';

class AddressList extends StatefulWidget {
  const AddressList({super.key});

  @override
  State<AddressList> createState() => _AddressListState();
}

class _AddressListState extends State<AddressList> {
  FirebaseService firebaseService = FirebaseService();
  Future _showEditAddress(String bookingId, String currentAddress) async {
    TextEditingController addressController =
        TextEditingController(text: currentAddress);

    return showDialog(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Edit Address'),
          content: SingleChildScrollView(
            child: ListBody(
              children: [
                TextField(
                  controller: addressController,
                  decoration: const InputDecoration(
                    labelText: 'Address',
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Save'),
              onPressed: () async {
                await firebaseService.updateBookingAddress(
                    bookingId, addressController.text);
                Navigator.of(context).pop();
                setState(() {}); // Refresh the data
              },
            ),
          ],
        );
      },
    );
  }

  Future _showDeleteDialog(String bookingId) async {
    return showDialog(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Address'),
          content: const Text('Are you sure you want to delete this address?'),
          actions: [
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Delete'),
              onPressed: () async {
                await firebaseService.deleteBookingAddress(bookingId);
                Navigator.of(context).pop();
                setState(() {}); // Refresh the data
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: commonAppbar('Address'),
      backgroundColor: white,
      body: FadeIn(
          child: ListView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 20),
        children: [
          Text(
            'saved address'.toUpperCase(),
            textAlign: TextAlign.center,
            style: myFont500,
          ),
          30.height,
          FutureBuilder(
            future: firebaseService.getBookingData(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else {
                List<Map> bookingData = snapshot.data;
                return ListView.separated(
                  separatorBuilder: (context, index) => const SizedBox(
                    height: 20,
                  ),
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: bookingData.length,
                  itemBuilder: (context, index) {
                    return Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(color: Colors.grey),
                      ),
                      padding: const EdgeInsets.all(20),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(bookingData[index]['address'],
                                    style: myFont28_600),
                                10.height,
                              ],
                            ),
                          ),
                          10.width,
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              IconButton(
                                icon: const Icon(FontAwesomeIcons.pencil,
                                    color: skyBlue, size: 17),
                                onPressed: () {
                                  _showEditAddress(
                                      bookingData[index]['bookingID'],
                                      bookingData[index]['address']);
                                },
                              ),
                              20.height,
                              IconButton(
                                icon: const Icon(FontAwesomeIcons.trash,
                                    color: redColor, size: 17),
                                onPressed: () {
                                  _showDeleteDialog(
                                    bookingData[index]['bookingID'],
                                  );
                                },
                              ),
                            ],
                          )
                        ],
                      ),
                    );
                  },
                );
              }
            },
          ),
          const SizedBox(
            height: 20,
          ),
          DottedBorder(
            borderType: BorderType.RRect,
            radius: const Radius.circular(30),
            color: Utils().skyBlue,
            strokeWidth: 1,
            dashPattern: const [
              5,
              5,
            ],
            child: GestureDetector(
              onTap: () {
                AddAddressPage(isFromHome: true).launch(context);
              },
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    color: const Color.fromRGBO(225, 242, 242, 1)),
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.add,
                      color: Utils().lightBlue,
                    ),
                    Text("add new address".toUpperCase(),
                        style: myFont28_600.copyWith(color: Utils().lightBlue)),
                  ],
                ),
              ),
            ),
          ),
        ],
      )),
    );
  }
}
